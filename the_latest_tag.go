package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/blang/semver/v4"
)

func main() {
	tagsFromPodman := os.Getenv("TAGS")
	if mainCheckTags(tagsFromPodman) {
		os.Exit(1)
	}
}

// mainCheckTags — parse, filter and find the last tag
func mainCheckTags(stringTag string) bool {
	defaultTag := "1.0.0"

	// 1. If var TAGS is empty set to defaultTag
	if strings.TrimSpace(stringTag) == "" {
		fmt.Printf("LATEST_TAG=%s", defaultTag)
		return false
	}

	// 2. Parse string to map "image_name: [tags]"
	mapNameAndTags := mapNameTag(stringTag)

	// 3. If parse failed, set to defaultTag
	if len(mapNameAndTags) == 0 {
		fmt.Printf("LATEST_TAG=%s", defaultTag)
		return false
	}

	// 4. Get slice of tags
	sliceOfTags := getTagsOnly(mapNameAndTags)

	// 5. Filter and stay only tags which one == (x.y.z)
	validVersions := filterValidSemverTags(sliceOfTags)

	// 6. If after filter len for tag is == 0, set defaultTag
	if len(validVersions) == 0 {
		fmt.Printf("LATEST_TAG=%s", defaultTag)
		return false
	}

	// 7. Try to find the last tag, not the "latest" tag
	latest, err := findLatestVersion(validVersions)
	if err != nil {
		fmt.Printf("LATEST_TAG=%s", defaultTag)
		return false
	}

	fmt.Printf("LATEST_TAG=%s", latest)
	return false
}

// mapNameTag parse string to map.
func mapNameTag(s string) map[string][]string {
	mNameTags := make(map[string][]string)
	sliceImageTag := strings.Split(s, ",")

	for _, item := range sliceImageTag {
		item = strings.TrimSpace(item)
		if item == "" {
			continue
		}

		idx := strings.LastIndex(item, ":")
		if idx == -1 {
			fmt.Printf("WARNING: Invalid format in '%s', skipping\n", item)
			continue
		}

		tag := item[idx+1:]
		if tag == "" {
			fmt.Printf("WARNING: Invalid format in '%s', skipping\n", item)
			continue
		}

		// Get name, till ":" example >>> image:1.0.1, so var name will have value "image"
		name := item[:idx]
		// example for append {"../image": ["1.0.1", "latest"]}
		mNameTags[name] = append(mNameTags[name], tag)
	}
	return mNameTags
}

// getTagsOnly collect tags to slice
func getTagsOnly(m map[string][]string) []string {
	var sliceOfTags []string
	for _, v := range m {
		sliceOfTags = append(sliceOfTags, v...)
	}
	return sliceOfTags
}

// filterValidSemverTags filter and stay only === (x.y.z).
func filterValidSemverTags(tags []string) []string {
	versionRegex := regexp.MustCompile(`^\d+\.\d+\.\d+$`)
	var validVersions []string

	for _, tag := range tags {
		// Skip 'latest' and all which one not equal x.y.z
		if tag != "latest" && versionRegex.MatchString(tag) {
			validVersions = append(validVersions, tag)
		}
	}
	return validVersions
	// should be return only [1.0.1, 1.0.10, 1.0.11] without any v1.0.1, latest and other incorrect tags
}

// findLatestVersion compare version and return the lates tag
func findLatestVersion(versions []string) (string, error) {
	if len(versions) == 0 {
		return "", fmt.Errorf("list is empty")
	}

	// Parse first for future compare
	latest, err := semver.Parse(versions[0])
	if err != nil {
		return "", fmt.Errorf("incorrect version %s: %v", versions[0], err)
	}

	// Iterate over tag and search the last tag
	for _, vStr := range versions[1:] {
		v, err := semver.Parse(vStr)
		if err != nil {
			continue
		}
		if v.GT(latest) {
			latest = v
		}
	}
	return latest.String(), nil
}
