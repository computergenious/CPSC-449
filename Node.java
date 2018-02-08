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
            if(forbidden[i][task-1]){
                throw new Exception("forbidden machine");
            }

            //Checking too near task
            /*int prev;
            if (i == 0) {
                prev = PREV_VALUE;
            } else {
                prev = i-1;
            }*/
            int prev = prevMachIndex(i);

            /*int next;
            if (i == PREV_VALUE) {
                next = 0;
            } else {
                next = i+1;
            }*/
            int next = nextMachIndex(i);

            //Check to previous index
            if(pairs[prev] != DUMMY_VALUE) { //or pairs[prev] >= 0 && pairs[prev] < 8
                int prevTask = pairs[prev];
                if(tooNearTask[prevTask-1][task-1]){
                    throw new Exception("too near task prev");
                }
            }

            //Check to next index
            if(pairs[next]!= DUMMY_VALUE){
                int nextTask = pairs[next];
                if(tooNearTask[task-1][nextTask-1]){
                    throw new Exception("too near task next");
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
        
        // int task;

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

        for(; machine < ARRAY_SIZE; machine++) {
            if (pairs[machine] == DUMMY_VALUE) {
                return machine;
            }
        }

        /*while (pairs[machine] != DUMMY_VALUE) {
            machine++;
        }*/

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

        //int index = 0;
        for(int i = 0; i < ARRAY_SIZE; i++) {
            if(!taskTaken[i]) {
                result[--size] = i;
                // result[index] = i;
                // index++;
            }
        }

        return result;
    }

    //placeholder
    private int penalty(){
        int taskValue;
        int machineValue;

        /*
         *
         * PARSE THROUGH THE FINAL SOLUTION ARRAY
         * AND GRAB THE INDEX AS WELL AS THE ELEMENT THEN PUT THEM BOTH INTO THE
         * machineValue and taskValue VARIABLES RESPECTIVELY
         *
         */

        for(int i = 0; i < pairs.length; i++) {
            taskValue = pairs[i];
            machineValue = i;
            System.out.println("Result is: " + taskValue + "," +  machineValue);

            /*
             * TAKE THE taskValue AND machineValue VARIABLES AND USE THEM AS CO-ORDINATES TO LOCATE
             * THE PENALTY VALUE WITHIN THE Penalties 2D ARRAY.
             *
             */

            penaltyPoints += mainIO.penaltyArray[machineValue][taskValue];

            int prevIndex = prevMachIndex(i);
            penaltyPoints += mainIO.tooNearPenalty[pairs[prevIndex]][pairs[i]];
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
            case 1:
                letter = "A";
                break;
            case 2:
                letter = "B";
                break;
            case 3:
                letter = "C";
                break;
            case 4:
                letter = "D";
                break;
            case 5:
                letter = "E";
                break;
            case 6:
                letter = "F";
                break;
            case 7:
                letter = "G";
                break;
            case 8:
                letter = "H";
                break;
            default:
                letter = "";
                break;
        }

        return letter;
    }

    public String toString() {
        String result = "Solution ";
        for (int i : pairs) {
            result = result.concat(getTaskLetter(i));
            //result = result.concat(" ");
        }
        result = result + "; Quality: ";
        result = result + getPenaltyPoints();

        return result;
    }

}
