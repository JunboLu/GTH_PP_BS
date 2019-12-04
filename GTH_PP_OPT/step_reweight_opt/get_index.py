#! /bin/env/python

import linecache

total_step = len(open('kk','rU').readlines())

def get_index():
  value = []
  for i in range(total_step):
    line = linecache.getline('kk',i+1)
    b = []
    a = line.split(' ')
    for k in range(len(a)):
      if (a[k] != ''):
        b.append(a[k])
    value.append(float(b[len(b)-1]))
  min_index = value.index(min(value))
  line = linecache.getline('kk',min_index+1)
  if (len(line)==98):
    pre_step_size = line[5:7]
  else:
    pre_step_size = line[5:6]
  return pre_step_size

if __name__ == '__main__':
  get_index()
