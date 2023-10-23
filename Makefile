push:
	docker buildx build -t dockerscoutpolicy/high-profile-cves --platform linux/amd64,linux/arm64 --push --sbom=1 --provenance=1 .
