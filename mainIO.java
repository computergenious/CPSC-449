import java.io.*;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.LinkedList;

public class mainIO{
    public static int[][] machinePenalties = new int[8][8];
    public static int[][] tooNearPenalties = new int[8][8];
    
    public static void main(String[] args) {
        	try{
	        Scanner fileScanner = new Scanner(new BufferedReader(new FileReader(args[0])));
	
            String line = trimSpaces(fileScanner.nextLine());
            
            if(!line.equals("Name:")){
                throw new Exception("Error while parsing input file");
            }
            
			String name = trimSpaces(fileScanner.nextLine()); 
		    
			line = skipBlankLines(fileScanner);

			System.out.println(line);

            
            if(!line.equals("forced partial assignment:")){
                throw new Exception("Error while parsing input file");
            }
			
			int[] forcedAssignments = new int[8];
			for(int i = 0; i < 8; i++){
				forcedAssignments[i] = -1;
			}

			int machineForce;
			int taskForce;

			for(String lineInList : getLines(fileScanner)){
				String[] split = lineInList.substring(1, lineInList.length() - 1).split(",");
				try {
					machineForce = Integer.parseInt(split[0])-1;
				} catch (Exception e){
					throw new Exception("invalid machine/task");
				}
				taskForce = getTaskNumber(split[1]);
				
				if(machineForce>7 || machineForce<0 || taskForce>7 || taskForce<0) {
                    throw new Exception("invalid machine/task");
                }
				if(forcedAssignments[machineForce] != -1) {
                    throw new Exception("partial assignment error");
                }
			
				forcedAssignments[machineForce] = taskForce;
			}

		    for (int m=0; m<8; m++){
		    	if (forcedAssignments[m] != -1){
			    	for (int n=0; n<8; n++){
			    		if (n!=m && forcedAssignments[n] == forcedAssignments[m]){
			    			throw new Exception("partial assignment error");
			    		}
			    	}
		    	}
			}

			System.out.println("FORCED PARTIAL ARRAY");
            for (int i = 0; i<forcedAssignments.length; i++) {
                System.out.print(Node.getTaskLetter(forcedAssignments[i]) + " ");
            }
			System.out.println();

			line = skipBlankLines(fileScanner);
			
			System.out.println(line);

	        
            if(!line.equals("forbidden machine:")){
                throw new Exception("Error while parsing input file");
            }
            
			boolean[][] forbiddenMachine = new boolean[8][8];

			int machineForbid;
			int taskForbid;

			for(String lineInList : getLines(fileScanner)){
				String[] split = lineInList.substring(1, lineInList.length() - 1).split(",");
				try {
					machineForbid = Integer.parseInt(split[0])-1 ;
				} catch (Exception e)
				{
					throw new Exception("invalid machine/task");
				}
				taskForbid = getTaskNumber(split[1]);
				
				if(taskForbid<0 || taskForbid>7) {
                    throw new Exception("invalid machine/task");
                }

				forbiddenMachine[machineForbid][taskForbid] = true;
			}

			System.out.println("FORBIDDEN ARRAY");
            for (int k = 0; k < forbiddenMachine.length; k++) {
                for (int j = 0; j < forbiddenMachine.length; j++)
                {
                    System.out.print(forbiddenMachine[k][j] + " ");
                }
                System.out.println();
            }
	        
			line = skipBlankLines(fileScanner);
			
			System.out.println(line);
	        
            if(!line.equals("too-near tasks:")){
                throw new Exception("Error while parsing input file");
            }

			boolean[][] tooNear = new boolean [8][8];
			int task1TooNear;
			int task2TooNear;
			for(String lineinList : getLines(fileScanner)){
				String[] split = lineinList.substring(1, lineinList.length() - 1).split(",");
				task1TooNear = getTaskNumber(split[0]);
				task2TooNear = getTaskNumber(split[1]);
				if(task2TooNear < 0 || task1TooNear < 0) {
                    throw new Exception("invalid machine/task");
                }
				tooNear[task1TooNear][task2TooNear] = true;
			}

			System.out.println("TOO NEAR TASK ARRAY");
            for (int k = 0; k < tooNear.length; k++) {
                for (int j = 0; j < tooNear.length; j++) {
                    System.out.print(tooNear[k][j] + " ");
                }
                System.out.println();
            }
	
			line = skipBlankLines(fileScanner);
			
			System.out.println(line);
	        
            if(!line.equals("machine penalties:")){
                throw new Exception("Error while parsing input file");
            }

            LinkedList<String> input = getLines(fileScanner);
			if (input.size() != 8) throw new Exception("machine penalty error");

			int i = 0;
			for(String lineInList : input){
				String[] split = lineInList.split(" ");
				
				if(split.length != 8) {
                    throw new Exception("machine penalty error");
                }

				for(int j = 0; j < 8; j++){
					try{
						machinePenalties[i][j] = Integer.parseInt(split[j]);
						if (machinePenalties[i][j] < 0){
							throw new Exception("invalid penalty");
						}
					} catch (NumberFormatException e){
						throw new Exception("invalid penalty");
					}
				}

				i++;
			}

			System.out.println("MACHINE PENALTIES");
            for (int k = 0; k < machinePenalties.length; k++) {
                for (int j = 0; j < machinePenalties.length; j++) {
                    System.out.print(machinePenalties[k][j] + " ");
                }
                System.out.println();
            }
	
			line = skipBlankLines(fileScanner);
			
			System.out.println(line);
	        
			if(!line.equals("too-near penalties:"))	{
				if (!line.equals("too-near penalities")) {
					throw new Exception("Error while parsing input file");
				}
			}

			int task1, task2, value;
			for(String lineInList : getLines(fileScanner)){
				String[] split = lineInList.substring(1, lineInList.length() - 1).split(",");
				task1 = getTaskNumber(split[0]);
				task2 = getTaskNumber(split[1]);
				
				if(task1 < 0 || task2 < 0) {
                    throw new Exception("invalid task");
                }
				try{
					value = Integer.parseInt(split[2]);
				} catch (NumberFormatException e){
					throw new Exception("invalid penalty");
				}

				tooNearPenalties[task1][task2] = value;
			}

			System.out.println("TOO NEAR PENALTIES");
            for (int k = 0; k < tooNearPenalties.length; k++) {
                for (int j = 0; j < tooNearPenalties.length; j++) {
                    System.out.print(tooNearPenalties[k][j] + " ");
                }
                System.out.println();
            }

			
			while(fileScanner.hasNext()){
				if(!fileScanner.nextLine().trim().equals("")) {
                    throw new Exception("Error while parsing input file");
                }
			}
            
            
            Node rootNode = new Node(forcedAssignments, forbiddenMachine, tooNear);
            System.out.println(rootNode.toString());

            Node solution;
            solution = BranchAndBound.branchAndBound(rootNode, null, forbiddenMachine, tooNear);

            if(solution != null) {
                writeToFile(solution.toString(), args[1]);
            } else {
                String noSolStr = "No valid solution possible!";
                writeToFile(noSolStr, args[1]);
            }
            
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            writeToFile(e.getMessage(), args[1]);
        }
    }

    private static String trimSpaces(String s){
        if (s != null) {
        	int i = s.length() - 1;
            for(; i >= 0 && Character.isWhitespace(s.charAt(i)); i--);
            return s.substring(0, i + 1);
        } else {
            return null;
        }
    }

    public static int getTaskNumber(String task){
        if(task.equals("A")) {
            return 0;
        } else if(task.equals("B")) {
            return 1;
        } else if(task.equals("C")) {
            return 2;
        } else if(task.equals("D")) {
            return 3;
        } else if(task.equals("E")) {
            return 4;
        } else if(task.equals("F")) {
            return 5;
        } else if(task.equals("G")) {
            return 6;
        } else if(task.equals("H")) {
            return 7;
        } else {
            return -1;
        }
    }
        
    private static LinkedList<String> getLines(Scanner fileScanner){
        LinkedList<String> lines = new LinkedList<String>();
        String line;
        if(fileScanner.hasNext()){
        	line = trimSpaces(fileScanner.nextLine());
        	while(!line.equals("")){
        		lines.add(line);
        		if(fileScanner.hasNext()){
        			line = trimSpaces(fileScanner.nextLine());
        		} else {
        			line = "";
        		}
        	}
        }
        return lines;
    }

    private static String skipBlankLines(Scanner fileScanner) throws Exception{
    	String line = null;
    	if(fileScanner.hasNext()){
    		line = fileScanner.nextLine();
    		while(line.equals("") && fileScanner.hasNext()){
    			line = fileScanner.nextLine();
    		}
        }
        
    	if(line != null && !line.equals("")){
    		return line;
    	} else {
            throw new Exception("Error while parsing input file");
        }	
    }
    
    private static void writeToFile(String inputStringToFile, String fileName) {
        try {
            
            PrintWriter fw = new PrintWriter(fileName,"UTF16");
            
            BufferedWriter buffWriter = new BufferedWriter(fw);
            buffWriter.write(inputStringToFile);
            buffWriter.newLine();
            buffWriter.close();
            
            System.out.println(inputStringToFile);
            System.out.println("Done writing to file.");
            
        } catch (IOException e) {
            System.out.println("Error writing to file");
        }
    }
}

