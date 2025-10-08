#!/usr/bin/env python3
"""
Context Caching System - Smart Context Loading
Part of Plan Maestro Phase 4: Optimize

Implements intelligent caching of frequently accessed files to reduce token usage.

Features:
- LRU cache for file contents
- Timestamp-based invalidation
- Automatic cache warming
- Hit/miss tracking
- Memory-efficient storage

Usage:
    python scripts/context-cache.py --warm    # Warm cache with essential files
    python scripts/context-cache.py --stats   # Show cache statistics
    python scripts/context-cache.py --clear   # Clear cache
"""

import json
import os
import sys
import hashlib
from datetime import datetime, timedelta
from pathlib import Path
from collections import OrderedDict

# Configuration
CACHE_DIR = ".cache/context"
CACHE_MAX_SIZE = 50  # Max files to cache
CACHE_TTL_MINUTES = 60  # Time to live in minutes
ESSENTIAL_FILES = [
    "CLAUDE.md",
    "docs/CONTEXT_LAST_SESSION.md",
    "docs/PROJECT_INDEX.md",
    "docs/PROJECT_STATUS.md",
    "docs/BILINGUAL_GUIDE.md",
    "docs/WORKFLOW_TEMPLATES.md"
]

class ContextCache:
    """LRU cache for project files"""

    def __init__(self, cache_dir=CACHE_DIR, max_size=CACHE_MAX_SIZE, ttl_minutes=CACHE_TTL_MINUTES):
        self.cache_dir = Path(cache_dir)
        self.max_size = max_size
        self.ttl = timedelta(minutes=ttl_minutes)
        self.cache = OrderedDict()
        self.stats = {
            'hits': 0,
            'misses': 0,
            'invalidations': 0,
            'total_tokens_saved': 0
        }

        # Create cache directory
        self.cache_dir.mkdir(parents=True, exist_ok=True)

        # Load existing cache
        self._load_cache()

    def _load_cache(self):
        """Load cache index from disk"""
        index_file = self.cache_dir / "index.json"
        if index_file.exists():
            with open(index_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.cache = OrderedDict(data.get('cache', {}))
                self.stats = data.get('stats', self.stats)

    def _save_cache(self):
        """Save cache index to disk"""
        index_file = self.cache_dir / "index.json"
        data = {
            'cache': dict(self.cache),
            'stats': self.stats,
            'last_updated': datetime.now().isoformat()
        }
        with open(index_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2)

    def _get_file_hash(self, file_path):
        """Calculate file content hash"""
        if not os.path.exists(file_path):
            return None

        with open(file_path, 'rb') as f:
            return hashlib.md5(f.read()).hexdigest()

    def _is_valid(self, entry):
        """Check if cache entry is still valid"""
        # Check TTL
        cached_time = datetime.fromisoformat(entry['timestamp'])
        if datetime.now() - cached_time > self.ttl:
            return False

        # Check file hash
        current_hash = self._get_file_hash(entry['path'])
        if current_hash != entry['hash']:
            return False

        return True

    def get(self, file_path):
        """Get file from cache or disk"""
        file_path = str(file_path)

        # Check if in cache
        if file_path in self.cache:
            entry = self.cache[file_path]

            # Validate entry
            if self._is_valid(entry):
                # Move to end (most recently used)
                self.cache.move_to_end(file_path)
                self.stats['hits'] += 1

                # Calculate tokens saved (rough estimate)
                tokens_saved = entry['size'] // 4  # ~4 chars per token
                self.stats['total_tokens_saved'] += tokens_saved

                return {
                    'content': entry['content'],
                    'from_cache': True,
                    'tokens_saved': tokens_saved
                }
            else:
                # Invalid, remove from cache
                del self.cache[file_path]
                self.stats['invalidations'] += 1

        # Not in cache or invalid, load from disk
        self.stats['misses'] += 1
        return self._load_and_cache(file_path)

    def _load_and_cache(self, file_path):
        """Load file from disk and add to cache"""
        if not os.path.exists(file_path):
            return {
                'content': None,
                'from_cache': False,
                'error': 'File not found'
            }

        # Read file
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Create cache entry
        file_hash = self._get_file_hash(file_path)
        entry = {
            'path': file_path,
            'content': content,
            'hash': file_hash,
            'size': len(content),
            'timestamp': datetime.now().isoformat()
        }

        # Add to cache
        self.cache[file_path] = entry

        # Evict oldest if cache full
        if len(self.cache) > self.max_size:
            self.cache.popitem(last=False)

        # Save cache
        self._save_cache()

        return {
            'content': content,
            'from_cache': False,
            'tokens_saved': 0
        }

    def warm(self, file_list=None):
        """Pre-load essential files into cache"""
        if file_list is None:
            file_list = ESSENTIAL_FILES

        warmed = 0
        failed = []

        for file_path in file_list:
            if os.path.exists(file_path):
                self.get(file_path)
                warmed += 1
            else:
                failed.append(file_path)

        return {
            'warmed': warmed,
            'failed': failed,
            'total': len(file_list)
        }

    def clear(self):
        """Clear all cache"""
        self.cache.clear()
        self.stats = {
            'hits': 0,
            'misses': 0,
            'invalidations': 0,
            'total_tokens_saved': 0
        }
        self._save_cache()

    def get_stats(self):
        """Get cache statistics"""
        total_requests = self.stats['hits'] + self.stats['misses']
        hit_rate = (self.stats['hits'] / total_requests * 100) if total_requests > 0 else 0

        return {
            'cache_size': len(self.cache),
            'max_size': self.max_size,
            'hits': self.stats['hits'],
            'misses': self.stats['misses'],
            'invalidations': self.stats['invalidations'],
            'hit_rate': round(hit_rate, 1),
            'tokens_saved': self.stats['total_tokens_saved']
        }

def print_header():
    """Display header"""
    print()
    print("=" * 80)
    print("  CONTEXT CACHE - Smart File Loading")
    print("=" * 80)
    print()

def main():
    """Main execution"""
    try:
        print_header()

        cache = ContextCache()

        # Handle commands
        if '--warm' in sys.argv:
            print("[WARMING CACHE]")
            print("-" * 80)
            result = cache.warm()
            print(f"Files warmed: {result['warmed']}/{result['total']}")
            if result['failed']:
                print(f"Failed: {', '.join(result['failed'])}")
            print()

        if '--stats' in sys.argv:
            print("[CACHE STATISTICS]")
            print("-" * 80)
            stats = cache.get_stats()
            print(f"Cache size:       {stats['cache_size']}/{stats['max_size']}")
            print(f"Hits:             {stats['hits']}")
            print(f"Misses:           {stats['misses']}")
            print(f"Hit rate:         {stats['hit_rate']}%")
            print(f"Invalidations:    {stats['invalidations']}")
            print(f"Tokens saved:     ~{stats['tokens_saved']:,}")
            print()

        if '--clear' in sys.argv:
            print("[CLEARING CACHE]")
            print("-" * 80)
            cache.clear()
            print("Cache cleared successfully")
            print()

        # Default: show stats
        if len(sys.argv) == 1:
            stats = cache.get_stats()
            print(f"Cache: {stats['cache_size']}/{stats['max_size']} files")
            print(f"Hit rate: {stats['hit_rate']}%")
            print(f"Tokens saved: ~{stats['tokens_saved']:,}")
            print()
            print("[TIP] Use --warm to pre-load essential files")
            print("[TIP] Use --stats for detailed statistics")
            print("[TIP] Use --clear to reset cache")
            print()

        print("=" * 80)
        print()

        return 0

    except Exception as e:
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
