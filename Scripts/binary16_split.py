#!/usr/bin/env python3

#* Helper script for binary16 *#
#*  Yigit Suoglu, 22/05/2021  *#

import sys

def split(value):
  value = int(value, 16)
  sign = (value >>15) & 1
  print("Sign:", sign)
  fra = value&1023
  print("Fraction:", hex(fra))
  exp = (value >>10)&31
  print("Exponent:", hex(exp))
  sign_ch = '+'
  if sign:
    sign_ch = '-'
  fra = 1.0 + float(fra/1024)
  exp -= 15
  if exp == -15:
    exp+=1
    fra-=1.0
  print(sign_ch,fra, "* 2^", exp, " = ",sign_ch, (fra * pow(2,exp)))

#Start here

print("This script splits binary16 values.")

if(len(sys.argv)==0):
  split(input("\n16 bit Hex: "))
else:
  sys.argv.pop(0)
  for val in sys.argv:
    print("\n",val,":",sep='')
    split(val)
