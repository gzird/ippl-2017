#!/bin/bash

set -v

antlr4 -Dlanguage=Python3 -visitor -no-listener quirk24.g4
