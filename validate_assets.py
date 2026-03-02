#!/usr/bin/env python3
"""
Asset Catalog Validation Script

Validates the FlappyDon asset catalog structure:
- Verifies all JSON files are valid
- Checks that all required imagesets exist
- Validates metadata consistency
- Reports any issues found
"""

import json
import os
from pathlib import Path
from typing import List, Tuple

# Expected imagesets based on ASSETS.md specification
EXPECTED_IMAGESETS = {
    'Characters': [
        'trump_idle_1',
        'trump_idle_2',
        'trump_flap_1',
        'trump_flap_2',
        'trump_dead',
        'trump_celebrate',
    ],
    'Obstacles': [
        'tower_top',
        'tower_bottom',
    ],
    'Backgrounds': [
        'sky_background',
        'cloud_1',
        'cloud_2',
        'cloud_3',
        'city_skyline',
        'ground_texture',
    ],
    'UI': [
        'logo',
        'button_play',
        'button_retry',
        'button_share',
        'button_menu',
        'icon_sound_on',
        'icon_sound_off',
        'medal_bronze',
        'medal_silver',
        'medal_gold',
        'medal_platinum',
        'badge_new',
        'gameover_banner',
    ],
}


def validate_json_file(filepath: Path) -> Tuple[bool, str]:
    """Validate that a file contains valid JSON."""
    try:
        with open(filepath, 'r') as f:
            json.load(f)
        return True, "Valid JSON"
    except json.JSONDecodeError as e:
        return False, f"Invalid JSON: {e}"
    except Exception as e:
        return False, f"Error reading file: {e}"


def validate_imageset_contents(filepath: Path, imageset_name: str) -> Tuple[bool, List[str]]:
    """Validate the Contents.json structure for an imageset."""
    issues = []
    
    try:
        with open(filepath, 'r') as f:
            data = json.load(f)
        
        # Check required keys
        if 'images' not in data:
            issues.append("Missing 'images' key")
        if 'info' not in data:
            issues.append("Missing 'info' key")
        
        # Check images array
        if 'images' in data:
            if not isinstance(data['images'], list):
                issues.append("'images' should be an array")
            elif len(data['images']) == 0:
                issues.append("'images' array is empty")
            else:
                # Check for @3x scale
                has_3x = any(
                    img.get('scale') == '3x' 
                    for img in data['images']
                )
                if not has_3x:
                    issues.append("Missing @3x scale image")
                
                # Check for filename
                for idx, img in enumerate(data['images']):
                    if 'filename' not in img:
                        issues.append(f"Image {idx} missing 'filename'")
                    if 'idiom' not in img:
                        issues.append(f"Image {idx} missing 'idiom'")
                    if 'scale' not in img:
                        issues.append(f"Image {idx} missing 'scale'")
        
        return len(issues) == 0, issues
    
    except Exception as e:
        return False, [f"Error validating: {e}"]


def main():
    """Run asset catalog validation."""
    print("=" * 70)
    print("FlappyDon Asset Catalog Validation")
    print("=" * 70)
    print()
    
    assets_dir = Path(__file__).parent / 'FlappyDon' / 'Resources' / 'Assets.xcassets'
    
    if not assets_dir.exists():
        print(f"❌ ERROR: Assets directory not found: {assets_dir}")
        return 1
    
    print(f"📁 Assets directory: {assets_dir}")
    print()
    
    total_checks = 0
    passed_checks = 0
    failed_checks = 0
    all_issues = []
    
    # Validate AppIcon
    print("🔍 Validating AppIcon...")
    appicon_json = assets_dir / 'AppIcon.appiconset' / 'Contents.json'
    if appicon_json.exists():
        valid, msg = validate_json_file(appicon_json)
        total_checks += 1
        if valid:
            passed_checks += 1
            print(f"  ✅ AppIcon/Contents.json: {msg}")
        else:
            failed_checks += 1
            print(f"  ❌ AppIcon/Contents.json: {msg}")
            all_issues.append(f"AppIcon/Contents.json: {msg}")
    else:
        failed_checks += 1
        print(f"  ❌ AppIcon/Contents.json: Not found")
        all_issues.append("AppIcon/Contents.json: Not found")
    
    print()
    
    # Validate each category
    for category, imagesets in EXPECTED_IMAGESETS.items():
        print(f"🔍 Validating {category}/ ({len(imagesets)} imagesets)...")
        category_dir = assets_dir / category
        
        if not category_dir.exists():
            print(f"  ❌ Category directory not found: {category}/")
            failed_checks += len(imagesets)
            all_issues.append(f"{category}/ directory not found")
            continue
        
        for imageset in imagesets:
            imageset_dir = category_dir / f"{imageset}.imageset"
            contents_json = imageset_dir / 'Contents.json'
            
            total_checks += 1
            
            if not imageset_dir.exists():
                failed_checks += 1
                print(f"  ❌ {category}/{imageset}.imageset: Directory not found")
                all_issues.append(f"{category}/{imageset}.imageset: Directory not found")
                continue
            
            if not contents_json.exists():
                failed_checks += 1
                print(f"  ❌ {category}/{imageset}/Contents.json: File not found")
                all_issues.append(f"{category}/{imageset}/Contents.json: File not found")
                continue
            
            # Validate JSON syntax
            valid, msg = validate_json_file(contents_json)
            if not valid:
                failed_checks += 1
                print(f"  ❌ {category}/{imageset}/Contents.json: {msg}")
                all_issues.append(f"{category}/{imageset}/Contents.json: {msg}")
                continue
            
            # Validate structure
            valid, issues = validate_imageset_contents(contents_json, imageset)
            if not valid:
                failed_checks += 1
                print(f"  ❌ {category}/{imageset}/Contents.json: {', '.join(issues)}")
                all_issues.extend([f"{category}/{imageset}/Contents.json: {issue}" for issue in issues])
            else:
                passed_checks += 1
                print(f"  ✅ {category}/{imageset}.imageset")
        
        print()
    
    # Summary
    print("=" * 70)
    print("VALIDATION SUMMARY")
    print("=" * 70)
    print(f"Total checks: {total_checks}")
    print(f"✅ Passed: {passed_checks}")
    print(f"❌ Failed: {failed_checks}")
    print()
    
    if failed_checks == 0:
        print("🎉 All validations passed!")
        print()
        print("✅ All JSON files are valid")
        print("✅ All required imagesets exist")
        print("✅ All imagesets have proper @3x configuration")
        print("✅ Asset catalog structure is complete")
        return 0
    else:
        print("⚠️  Validation issues found:")
        for issue in all_issues:
            print(f"  - {issue}")
        return 1


if __name__ == '__main__':
    exit(main())
