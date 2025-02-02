#!/usr/bin/env bash

# This script prints all environment variables in alphabetical order.
set -e -x

# Use printenv to list the environment variables, and pipe through sort.
printenv | sort

echo $(cat /etc/os-release)



# https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables

# On Linux:
# + GITHUB_ACTION=__run_2
# + GITHUB_ACTION_PATH=
# + GITHUB_ACTION_REPOSITORY=
# + GITHUB_ACTIONS=true
# + GITHUB_ACTOR=markuslf
# + GITHUB_ACTOR_ID=31855393
# + GITHUB_API_URL=https://api.github.com
# + GITHUB_BASE_REF=
# + GITHUB_ENV=/home/runner/work/_temp/_runner_file_commands/set_env_ea6ccf34-3f3d-4086-b484-056eed4e7bd1
# + GITHUB_EVENT_NAME=workflow_dispatch
# + GITHUB_EVENT_PATH=/home/runner/work/_temp/_github_workflow/event.json
# + GITHUB_GRAPHQL_URL=https://api.github.com/graphql
# + GITHUB_HEAD_REF=
# + GITHUB_JOB=build-packages
# + GITHUB_OUTPUT=/home/runner/work/_temp/_runner_file_commands/set_output_ea6ccf34-3f3d-4086-b484-056eed4e7bd1
# + GITHUB_PATH=/home/runner/work/_temp/_runner_file_commands/add_path_ea6ccf34-3f3d-4086-b484-056eed4e7bd1
# + GITHUB_REF=refs/heads/main
# + GITHUB_REF_NAME=main
# + GITHUB_REF_PROTECTED=false
# + GITHUB_REF_TYPE=branch
# + GITHUB_REPOSITORY=Linuxfabrik/buildtest
# + GITHUB_REPOSITORY_ID=924666315
# + GITHUB_REPOSITORY_OWNER=Linuxfabrik
# + GITHUB_REPOSITORY_OWNER_ID=24634880
# + GITHUB_RETENTION_DAYS=90
# + GITHUB_RUN_ATTEMPT=1
# + GITHUB_RUN_ID=13099792804
# + GITHUB_RUN_NUMBER=43
# + GITHUB_SERVER_URL=https://github.com
# + GITHUB_SHA=cb43b5eaf3c571382eba89089742dcbb9c8c3852
# + GITHUB_STEP_SUMMARY=/home/runner/work/_temp/_runner_file_commands/step_summary_ea6ccf34-3f3d-4086-b484-056eed4e7bd1
# + GITHUB_TRIGGERING_ACTOR=markuslf
# + GITHUB_WORKFLOW='Linuxfabrik: Build Linux (x86_64)'
# + GITHUB_WORKFLOW_REF=Linuxfabrik/buildtest/.github/workflows/lf-build-linux-x86_64.yml@refs/heads/main
# + GITHUB_WORKFLOW_SHA=cb43b5eaf3c571382eba89089742dcbb9c8c3852
# + GITHUB_WORKSPACE=/home/runner/work/buildtest/buildtest
# + RUNNER_ARCH=X64
# + RUNNER_DEBUG=
# + RUNNER_ENVIRONMENT=github-hosted
# + RUNNER_NAME='GitHub Actions 7'
# + RUNNER_OS=Linux
# + RUNNER_TEMP=/home/runner/work/_temp
# + RUNNER_TOOL_CACHE=/opt/hostedtoolcache

# On Windows:
# + GITHUB_ACTION=__run
# + GITHUB_ACTION_PATH=
# + GITHUB_ACTION_REPOSITORY=
# + GITHUB_ACTIONS=true
# + GITHUB_ACTOR=markuslf
# + GITHUB_ACTOR_ID=31855393
# + GITHUB_API_URL=https://api.github.com
# + GITHUB_BASE_REF=
# + GITHUB_ENV='D:\a\_temp\_runner_file_commands\set_env_0ff0157a-0779-4955-91e4-592a24b60b6e'
# + GITHUB_EVENT_NAME=workflow_dispatch
# + GITHUB_EVENT_PATH='D:\a\_temp\_github_workflow\event.json'
# + GITHUB_GRAPHQL_URL=https://api.github.com/graphql
# + GITHUB_HEAD_REF=
# + GITHUB_JOB=build-packages
# + GITHUB_OUTPUT='D:\a\_temp\_runner_file_commands\set_output_0ff0157a-0779-4955-91e4-592a24b60b6e'
# + GITHUB_PATH='D:\a\_temp\_runner_file_commands\add_path_0ff0157a-0779-4955-91e4-592a24b60b6e'
# + GITHUB_REF=refs/heads/main
# + GITHUB_REF_NAME=main
# + GITHUB_REF_PROTECTED=false
# + GITHUB_REF_TYPE=branch
# + GITHUB_REPOSITORY=Linuxfabrik/buildtest
# + GITHUB_REPOSITORY_ID=924666315
# + GITHUB_REPOSITORY_OWNER=Linuxfabrik
# + GITHUB_REPOSITORY_OWNER_ID=24634880
# + GITHUB_RETENTION_DAYS=90
# + GITHUB_RUN_ATTEMPT=1
# + GITHUB_RUN_ID=13099774721
# + GITHUB_RUN_NUMBER=24
# + GITHUB_SERVER_URL=https://github.com
# + GITHUB_SHA=caad7ff5b83bd8ceed266f8e39ad6bd1846eeeef
# + GITHUB_STEP_SUMMARY='D:\a\_temp\_runner_file_commands\step_summary_0ff0157a-0779-4955-91e4-592a24b60b6e'
# + GITHUB_TRIGGERING_ACTOR=markuslf
# + GITHUB_WORKFLOW='Linuxfabrik: Build Windows (x86_64)'
# + GITHUB_WORKFLOW_REF=Linuxfabrik/buildtest/.github/workflows/lf-build-windows-x86_64.yml@refs/heads/main
# + GITHUB_WORKFLOW_SHA=caad7ff5b83bd8ceed266f8e39ad6bd1846eeeef
# + GITHUB_WORKSPACE='D:\a\buildtest\buildtest'
# + RUNNER_ARCH=X64
# + RUNNER_DEBUG=
# + RUNNER_ENVIRONMENT=github-hosted
# + RUNNER_NAME='GitHub Actions 17'
# + RUNNER_OS=Windows
# + RUNNER_TEMP='D:\a\_temp'
# + RUNNER_TOOL_CACHE='C:\hostedtoolcache\windows'

