#!/bin/bash

SOURCE_IMAGE=$1
TARGET_IMAGE=$2

MANIFEST=$(docker manifest inspect "$SOURCE_IMAGE" 2>/dev/null)
if [ $? -ne 0 ]; then
	echo "Error: image '$SOURCE_IMAGE' not found or inaccessible."
	exit 1
fi

PLATFORMS=("linux/amd64" "linux/arm64")
DIGESTS=()
for PLATFORM in "${PLATFORMS[@]}"; do
	DIGEST=$(echo "$MANIFEST" | jq -r ".manifests[] | select(.platform.os + \"/\" + .platform.architecture == \"$PLATFORM\") | .digest")
	if [ -z "$DIGEST" ]; then
		echo "Error: Platform '$PLATFORM' not found in the source image manifest."
		exit 1
	fi
	DIGESTS+=("$DIGEST")
done

for i in "${!PLATFORMS[@]}"; do
	PLATFORM=${PLATFORMS[$i]}
	DIGEST=${DIGESTS[$i]}
	ARCH=${PLATFORM##*/}

	SOURCE_TAG="$SOURCE_IMAGE@$DIGEST"
	TARGET_TAG="$TARGET_IMAGE-$ARCH"

	echo "Processing platform: $PLATFORM"
	docker pull "$SOURCE_TAG"
	docker tag "$SOURCE_TAG" "$TARGET_TAG"
	docker push "$TARGET_TAG"
done

echo "Creating multi-platform manifest: $TARGET_IMAGE"
docker manifest create "$TARGET_IMAGE" \
	$(for PLATFORM in "${PLATFORMS[@]}"; do
		ARCH=${PLATFORM##*/}
		echo "--amend $TARGET_IMAGE-$ARCH"
	done)

echo "Pushing multi-platform manifest to target registry: $TARGET_IMAGE"
docker manifest push "$TARGET_IMAGE"

echo "Done! Multi-platform image has been successfully published to $TARGET_IMAGE"
