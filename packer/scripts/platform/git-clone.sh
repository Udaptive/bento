#!/bin/sh

pushd ~
git clone "https://$GIT_USERNAME:$GIT_PASSWORD@github.com/$GIT_REPO" --branch $GIT_BRANCH
popd
