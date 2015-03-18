import sys
import random

dictionary = dict()

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


    temp = []
    temp.append(wall)
    temp.append(row)
    temp.append(column)
    temp.append(endTime)

    if startTime in dictionary:
        dictionary[startTime].append(temp)
    else:
        container = []
        container.append(temp)
        dictionary[startTime] = container;

    i = i + 1

#keys = sorted(keys)
#print keys
#print dictionary
#print sorted(dictionary)
#print dictionary
for k in dictionary.keys():
    temp = dictionary[k]
    for val in temp:
        strStartTime = str(k)
        strEndTime = str(val[3])

        if len(strEndTime) == 1:
            strEndTime = "0" + strEndTime
        if len(strStartTime) == 1:
            strStartTime = "000" + strStartTime
        elif len(strStartTime) == 2:
            strStartTime = "00" + strStartTime
        elif len(strStartTime) == 3:
            strStartTime = "0" + strStartTime

        strWall = str(val[0])
        strRow = str(val[1])
        strColumn = str(val[2])

        step = strStartTime + strWall + strRow + strColumn + strEndTime
        target.write(step)

        print "-------------------------------------"
        print strStartTime
        print strWall
        print strRow
        print strColumn
        print strEndTime
        print step

target.close()

    


    


