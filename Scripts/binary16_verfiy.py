#!/usr/bin/env python3

#* Helper script for binary16 *#
#*  Yigit Suoglu, 20/05/2021  *#

def calculate(multi,val1,val2):
  if multi:
    print("\nMultiplying...\n")
    res = val1 * val2
  else:
    print("\nAdding...\n")
    res = val1 + val2
  print("Result: ", res)
  sign_bin = 0
  sign_res = '+'
  if res < 0:
    sign_res = '-'
    sign_bin = 1
    res*=-1
  print("Sign: ",sign_res)
  exp_res = 15
  frac_res = 0
  if res < 1:
    while res < 1:
      res*=2
      exp_res-=1
      if exp_res == 0:
        break
    if exp_res == 0:
      res/=2
    else:
      res-=1
  elif 2 < res:
    while 2 < res:
      res/=2
      exp_res+=1
      if exp_res == 31:
        print("\nOverflow!")
        return 
    res-=1
  if res == 1:
    res = 0
    exp_res+=1
  else:
    res*=1024
  frac_res = int(res)
  if (res - float(frac_res)) > 0.5:
    frac_res+=1
  print("Fraction:", hex(frac_res))
  print("Exponent:", hex(exp_res))
  val = ((sign_bin&1) << 15) + ((exp_res&31) << 10) + (frac_res&1023)
  print("In Hex:", hex(val))
      

print("This script calculates the result of binary16 operation.")

print("\nFirst operand")
sign1 = 2
frac1 = 1024
exp1 = 32

while sign1 > 1:
  sign1 = int(input("Sign bit (bin): "))

sign1 = (sign1 == 1)

while frac1 > 1023:
  frac1 = input("Fractional part (hex): ")
  frac1 = int(frac1, 16)

frac1 = 1 + float(frac1/1024)

while exp1 > 31:
    exp1 = input("Exponential part (hex): ")
    exp1  = int(exp1, 16)

exp1 -= 15

if exp1 == -15:
  exp1+=1
  frac1-=1

val1 = frac1 * pow(2,exp1)

if sign1:
  val1*=-1

print("\nFirst operand: ", end='')
if sign1:
  print("-", end=' ')
else:
  print("+", end=' ')
print(frac1, "* 2^", exp1, " = ", val1)

if exp1 == 16:
  if frac1 == 1.0:
    print("Operand 1 is infinite!")
  else:
    print("Operand 1 is a NaN!")
  quit()

print("\nSecond operand")
sign2 = 2
frac2 = 1024
exp2 = 32

while sign2 > 1:
  sign2 = int(input("Sign bit (bin): "))

sign2 = (sign2 == 1)

while frac2 > 1023:
  frac2 = input("Fractional part (hex): ")
  frac2 = int(frac2, 16)

frac2 = 1 + float(frac2/1024)

while exp2 > 31:
    exp2 = input("Exponential part (hex): ")
    exp2  = int(exp2, 16)

exp2 -= 15

if exp2 == -15:
  exp2+=1
  frac2-=1

val2 = frac2 * pow(2,exp2)

if sign2:
  val2*=-1

print("\nSecond operand: ", end='')
if sign2:
  print("-", end=' ')
else:
  print("+", end=' ')
print(frac2, "* 2^", exp2, " = ", val2)

if exp2 == 16:
  if frac2 == 1.0:
    print("Operand 2 is infinite!")
  else:
    print("Operand 2 is a NaN!")
  quit()

calculate(False,val1,val2)
calculate(True,val1,val2)
