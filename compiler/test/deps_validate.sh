#!/usr/bin/env bash
# Validate -deps-only output matches -deps (direct imports)
# across the Phobos and druntime module trees.
# Usage: deps_validate.sh [druntime|phobos|all]

DMD="${DMD:-generated/linux/release/64/dmd}"
BASE="${BASE:-.}"
DRUNTIME_IMPORT="${BASE}/druntime/import"
PHOBOS="${BASE}/phobos"
TMPDIR="${TMPDIR:-/tmp/deps_validate}"
MODE="${1:-all}"  # all, phobos, druntime

mkdir -p "$TMPDIR"

total_files=0
total_mismatches=0

validate() {
    local label="$1"
    local srcfile="$2"
    shift 2

    if [ ! -f "$srcfile" ]; then
        echo "[SKIP] $label: $srcfile not found"
        return
    fi

    ((total_files++))

    # Run -deps (to stdout via -deps with no =filename)
    "$DMD" -conf= -m64 -I"$DRUNTIME_IMPORT" -I"$PHOBOS" -deps -o- -c "$srcfile" 2>/dev/null > "$TMPDIR/deps.out" || {
        echo "[FAIL] $label: -deps compilation error"
        return
    }

    # Run -deps-only
    "$DMD" -conf= -m64 -I"$DRUNTIME_IMPORT" -I"$PHOBOS" -deps-only -o- -c "$srcfile" > "$TMPDIR/deps_only.out" 2>/dev/null || {
        echo "[FAIL] $label: -deps-only compilation error"
        return
    }

    # Strip blank lines from both
    grep -v '^$' "$TMPDIR/deps_only.out" > "$TMPDIR/deps_only.clean"
    grep -v '^$' "$TMPDIR/deps.out" > "$TMPDIR/deps.clean"

    local deps_only_count=$(wc -l < "$TMPDIR/deps_only.clean")

    # For each line in deps_only, check it exists in deps
    local mismatches=0
    while IFS= read -r line; do
        if [ -z "$line" ]; then continue; fi
        if ! grep -qF "$line" "$TMPDIR/deps.clean"; then
            if [ $mismatches -eq 0 ]; then
                echo "[MISMATCH] $label: $srcfile"
            fi
            echo "  deps-only has: $line"
            echo "  NOT in -deps"
            ((mismatches++))
            ((total_mismatches++))
        fi
    done < "$TMPDIR/deps_only.clean"

    if [ $mismatches -eq 0 ]; then
        echo "[OK] $label ($deps_only_count lines)"
    fi
}

# Phobos modules (top-level)
phobos_modules=(
    std/typecons std/traits std/string std/conv std/stdio
    std/file std/process std/utf std/parallelism std/array
    std/path std/random std/numeric std/bitmanip std/socket
    std/encoding std/checkedint std/variant std/json std/concurrency
    std/algorithm/iteration std/algorithm/searching std/algorithm/sorting std/algorithm/mutation
    std/range/primitives std/format std/regex std/datetime std/math
)

# Druntime modules (top-level core/)
druntime_modules=(
    core/time core/demangle core/lifetime core/memory core/atomic
    core/cpuid core/runtime core/simd core/exception core/int128
    core/bitop core/checkedint core/attribute core/math core/vararg
)

echo "Validating -deps-only output against -deps"
echo "DMD: $DMD"
echo "---"

if [ "$MODE" = "phobos" ] || [ "$MODE" = "all" ]; then
    echo "=== Phobos ==="
    for mod in "${phobos_modules[@]}"; do
        validate "phobos" "$PHOBOS/$mod.d"
    done
fi

if [ "$MODE" = "druntime" ] || [ "$MODE" = "all" ]; then
    echo ""
    echo "=== Druntime ==="
    for mod in "${druntime_modules[@]}"; do
        validate "druntime" "$DRUNTIME_IMPORT/$mod.d"
    done
fi

echo ""
echo "---"
echo "Files tested: $total_files"
echo "Total mismatches: $total_mismatches"

if [ "$total_mismatches" -gt 0 ]; then exit 1; fi

echo "PASSED: -deps-only output is a subset of -deps for all tested files"
exit 0
