#!/bin/sh
echo "push articles"
.scripts/backup.sh
hexo clean && hexo d