# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


## [1.0.2] - 2021-05-19
### Added
- Add Slack notifications to all jobs
- Add nightly build job and workflow
- Add workspace caching for node deps
- Add Noboru's fix to React app to fetch only jpg images

### Changed
- Split out Terraform DNS job in preparation for blue-green deploy support
- Optimize Dockerfile to reduce build time
- Minor Terraform bugfixes

## [1.0.1] - 2021-02-02
### Added
- Docker layer caching on Docker image build job
- Moved Docker image build job to before manual approval job

## [1.0.0] - 2021-02-02
### Added
- Initial working deployment of React app on ECS