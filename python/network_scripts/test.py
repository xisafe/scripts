#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-3-6
#Description:
# --------------------------------------------------
import re


file=open("color.txt")


if __name__ == "__main__":
    for line in file:
        f=re.findall(r"(.*\])(.*)",line)
        promte=f[0][0]
        mycmd=f[0][1]
        print(" %s\033[31m%s\033[0m\n" % (promte,mycmd), end="")

