#!/bin/sh

die () {
  printf "%s\n" "$*" >&2
  exit 1
}

PY_FILES="instruction_to_pcode"

isort --profile black -c $PY_FILES || die "isort failed"
black --check $PY_FILES || die "black reports a .py needs reformatting"
flake8 --max-line-length 88 --extend-ignore=E203,E302,E501,W291 $PY_FILES || die "flake8 found issues"
