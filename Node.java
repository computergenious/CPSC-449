package assignment;

public class Node {
    private static final int ARRAY_SIZE = 8;
    private static final int PREV_VALUE = 7;
    public static final int DUMMY_VALUE = -1;

    private int[] pairs = new int[ARRAY_SIZE];
    private boolean[] taskTaken = new boolean[ARRAY_SIZE];
    private int penaltyPoints;

    /* Initial assignment.Node/Root Setup */
    public Node(int [] forcedPartial, boolean[][] forbidden, boolean[][] tooNearTask) throws Exception {
        // Initialize
        for(int i = 0; i < ARRAY_SIZE; i++){
            pairs[i] = DUMMY_VALUE;
        }
    
        for(int i = 0; i < ARRAY_SIZE; i++) {
            int task = forcedPartial[i];

            if(task == DUMMY_VALUE) {
                continue;
            }

            if(pairs[i] == DUMMY_VALUE){
                pairs[i] = task;
            } else {
                throw new Exception("partial assignment error");
            }

            //Checking forbidden
            if(forbidden[i][task]){
                throw new Exception("forbidden machine");
            }

            //Checking too near task

            int prev = prevMachIndex(i);

            int next = nextMachIndex(i);

            //Check to previous index
            if(pairs[prev] != DUMMY_VALUE) { //or pairs[prev] >= 0 && pairs[prev] < 8
                int prevTask = pairs[prev];
                if(tooNearTask[prevTask][task]){
                    throw new Exception("invalid machine/task");
                }
            }

            //Check to next index
            if(pairs[next]!= DUMMY_VALUE){
                int nextTask = pairs[next];
                if(tooNearTask[task][nextTask]){
                    throw new Exception("invalid machine/task");
                }
            }
        }

        //Set tasks to taken
        for(int i : pairs){
            if(i != DUMMY_VALUE) { //i >=0 && i < ARRAY_SIZE
                taskTaken[i] = true;
            } 
        }

        // set penalty point for node
        setPenaltyPoints();
    }

    /* Copy Parent assignment.Node and Add Task*/
    public Node(Node node, int newMachine, int newTask) {
        //Copy arrays from parent node
        this.pairs = node.getPairsArray();
        this.taskTaken = node.getTaskTakenArray();
        
        int task;

        // for(int i = 0; i < 8; i++) {
        //     task = node.getTaskAtIndex(i);
        //     pairs[i] = task;
        //     if(task != -1) {
        //         taskTaken[task] = true;
        //     }
        // }

        //Add new task to child node
        taskTaken[newTask] = true;
        pairs[newMachine] = newTask;

        // set penalty point for node
        setPenaltyPoints();
    }

    private int[] getPairsArray() {
		int[] tempArray = new int[ARRAY_SIZE];

        System.arraycopy(pairs, 0, tempArray, 0, 8);

        /*for (int index = 0; index < 8; index++) {
            tempArray[index] = pairs[index];
        }*/

		return tempArray;
    }
    
    private boolean[] getTaskTakenArray() {
		boolean[] tempArray = new boolean[ARRAY_SIZE];

        System.arraycopy(taskTaken, 0, tempArray, 0, 8);

        /*for (int index = 0; index < 8; index++) {
            tempArray[index] = taskTaken[index];
        }*/

		return tempArray;
	}

    public int getTaskAtIndex(int machineIndex) {
        int task;

        task = pairs[machineIndex];

        return task;
    }

    public int getFirstAvailableMachine() {
        int machine = 0;

        // for(; machine < ARRAY_SIZE; machine++) {
        //     if (pairs[machine] == DUMMY_VALUE) {
        //         return machine;
        //     }
        // }

        while (pairs[machine] != DUMMY_VALUE) {
            machine++;
        }

        return machine;
    }

    public int getNumAvailableTasks(){
        int numTasks = 0;

         for(int value : pairs) {
             if(value == -1) {
                 numTasks++;
             }
         }

        /*for(int i = 0; i < ARRAY_SIZE; i++){
            if(pairs[i] == -1) {
                numTasks++;
            }
        }*/

        return numTasks;
    }

    public int[] getRemainingTasks() {
        int size = getNumAvailableTasks();
        int[] result = new int[size];

        int index = 0;
        for(int i = 0; i < ARRAY_SIZE; i++) {
            if(!taskTaken[i]) {
        //        result[--size] = i;
                result[index] = i;
                index++;
            }
        }

        return result;
    }

    //placeholder
    private int penalty(){
        int taskValue;
        int machineValue;
		
        for(int i = pairs.length-1; i > -1 ; i--) {
            taskValue = pairs[i];
            machineValue = i;
            System.out.println("Result is(M,T): " + machineValue + "," +  taskValue);
			
            penaltyPoints += mainIO.penaltyArray[machineValue][taskValue];
            int nextIndex = nextMachIndex(i);
            penaltyPoints += mainIO.tooNearPenalty[pairs[i]][pairs[nextIndex]];
            
        }
        System.out.println("Total Penalty value is: " + penaltyPoints);

        return penaltyPoints;
    }


    public static int prevMachIndex(int index) {
        int machIndex;

        if (index == 0) {
            machIndex = PREV_VALUE;
        } else {
            machIndex = index - 1;
        }

        return machIndex;
    }

    public static int nextMachIndex(int index) {
        int machIndex;

        if (index == PREV_VALUE) {
            machIndex = 0;
        } else {
            machIndex = index + 1;
        }

        return machIndex;
    }

    private void setPenaltyPoints() {
        if (getNumAvailableTasks() == 0) {
            penaltyPoints = penalty();
        } else {
            penaltyPoints = Integer.MAX_VALUE;
        }
    }

    public int getPenaltyPoints() {
        return penaltyPoints;
    }

    private String getTaskLetter(int element) {
        String letter;
        switch (element) {
            case 0:
                letter = "A";
                break;
            case 1:
                letter = "B";
                break;
            case 2:
                letter = "C";
                break;
            case 3:
                letter = "D";
                break;
            case 4:
                letter = "E";
                break;
            case 5:
                letter = "F";
                break;
            case 6:
                letter = "G";
                break;
            case 7:
                letter = "H";
                break;
            default:
                letter = "-1";
                break;
        }

        return letter;
    }

    public String toString() {
        String result = "Solution ";
        String taskLetter = "";
        String subscript = "";

        //for (int i : pairs) {
        for (int i = 0; i<pairs.length; i++) {
            int element = pairs[i];
            result = result.concat(getTaskLetter(element));
            subscript = getUniCode(i);
            result += subscript;

            //result = result.concat(" ");
     //       taskLetter = getTaskLetter(i) + taskLetter;
            
        }
       // result = result + taskLetter;
    //    System.out.print(getTaskLetter(pairs[7]));
        result = result + "; Quality: ";
        result = result + getPenaltyPoints();

        return result;
    }

    public String getUniCode(int i) {
        String uniCode = "";
        switch(i) {
            case 0:
                uniCode = "\u2081";
                break;
            case 1:
                uniCode = "\u2082";
                break;
            case 2:
                uniCode = "\u2083";
                break;
            case 3:
                uniCode = "\u2084";
                break;
            case 4:
                uniCode = "\u2085";
                break;
            case 5:
                uniCode = "\u2086";
                break;
            case 6:
                uniCode = "\u2087";
                break;
            case 7:
                uniCode = "\u2088";
                break;
            default:
                break;
        }
        return uniCode;
    }

}
