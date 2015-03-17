import sys
import random

numberSteps = 100
minStartTime = 0
maxStartTime = 9999
minEndTime = 0
maxEndTime = 99

if len(sys.argv) < 2:
    print "Missing filename"
    quit()
    
if len(sys.argv) == 7:
	numberSteps = int(sys.argv[2])
	minStartTime = int(sys.argv[3])
	maxStartTime = int(sys.argv[4])
	minEndTime = int(sys.argv[5])
	maxEndTime = int(sys.argv[6])

filename = sys.argv[1]
target = open(filename, 'w')

i = 0

while i < numberSteps:
    startTime = random.randint(minStartTime,maxStartTime)
    endTime = random.randint(minEndTime,maxEndTime)
    wall = random.randint(0,3)
    row = random.randint(0,4)
    column = random.randint(0,2)
    
    strStartTime = str(startTime)
    strEndTime = str(endTime)
    
    if len(strEndTime) == 1:
        strEndTime = "0" + strEndTime
    
    if len(strStartTime) == 1:
        strStartTime = "000" + strStartTime
    elif len(strStartTime) == 2:
        strStartTime = "00" + strStartTime
    elif len(strStartTime) == 3:
        strStartTime = "0" + strStartTime
    
    
    strWall = str(wall)
    strRow = str(row)
    strColumn = str(column)
    
    step = strStartTime + strWall + strRow + strColumn + strEndTime
    target.write(step)
    
    print "-------------------------------------"
    print strStartTime
    print strWall
    print strRow
    print strColumn
    print strEndTime
    print step
    
    i = i + 1
    
target.close()

