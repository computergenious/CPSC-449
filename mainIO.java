/*
 * CPSC 449 Assignment 1
 * 
 * 
 * 
 * 
 */

//import necessary files
import java.io.*;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

public class mainIO {
	
	public static void main (String[] args) {
	
		Scanner fileScanner = null;
		String outputString = "";
	
		try {
		// initializes the main file reader and writer as well as the file scanner
		BufferedReader fileInput = new BufferedReader(new FileReader(args[0]));
		fileScanner = new Scanner(fileInput);
		}
		
		catch (IOException e) {
			System.out.println("Input file not found");
		}
		
		//initialized the force assignment array, penalty array, etc.
		int[] forcedAssignArray = new int[8];
		boolean[][] forbidden = new boolean[8][8];
		boolean[][] tooNear = new boolean[8][8];
		int[][] penaltyArray = new int[8][8];
		int[][] tooNearPenalty = new int[8][8];
		int flag = 0;
		
		//map A-H to 1-8
		Map<String, String> map = new HashMap<String, String>();
		map.put("A", "1");
		map.put("B", "2");
		map.put("C", "3");
		map.put("D", "4");
		map.put("E", "5");
		map.put("F", "6");
		map.put("G", "7");
		map.put("H", "8");
				
		// while loop to move through the file and check 
		while (fileScanner.hasNext()) {
			
			//assigns the next line to a string to be read and trims it
			String nextLine = fileScanner.nextLine();
			nextLine = nextLine.trim();
			
			
			
			//name check
			if (nextLine == "Name:" && flag == 0){
				fileScanner.nextLine();
				nextLine = fileScanner.nextLine();
				flag++;
			}
			
			//checks and initializes the forced partial assignment array
			if (nextLine == "forced partial assingnment:" && flag == 1) {
				
				//initialize the 
				for (int i=0;  i < 8; i++) 
				{
					forcedAssignArray[i] = -1;
				}

				//initialized the arraylist for 1 task two machine error
				ArrayList oneTaskTwoMachine = new ArrayList();
				//initialize the string for the current line
				String currentLine;
				
				//reads through the next (max) 8 lines for the data
				for ( int i=0; i < 8; i++) 
				{
					//progresses down one line to the data we want
					nextLine = fileScanner.nextLine();
					currentLine = nextLine.replaceAll("\\D+", "");//deletes everything except numbers
					
					//checks if there is no more data
					if (nextLine == "\n") break;
					
					//format the data to be easier to use
					int mach = Character.getNumericValue(currentLine.charAt(0));
					int task = Character.getNumericValue(currentLine.charAt(1));
					
					//check if there is a machine or task outside the usable values
					if (mach > 8) {
						//thrown invalideMachine error
						throw new Exception("Forced Partial Assignment Exception: invalid machine");
						//break;
					}
					if (task > 8) {
						//throw invalidTask error
						throw new Exception("Forced Partial Assignment Exception: invalid task");
						//break;
					}
					
					//check for two task one machine error
					if (forcedAssignArray[mach] != -1)
					{
						//throw exception
						throw new Exception("Forced Partial Assignment Exception: two tasks to one machine");
						//break;
					}
					
					//check for one task two machine error
					if (oneTaskTwoMachine.contains(task))
					{
						//throw exception
						throw new Exception("Forced Partial Assignment Exception: two machines for one task");
						//break;
					}
					
					else 
					{
						//if no errors are thrown adds the value to the arrays
						oneTaskTwoMachine.add(task);
						forcedAssignArray[mach - 1] = task;
					}
				}
				
				flag++;
			}
			
			
			
			
			
			if (nextLine == "forbidden machine:" && flag == 2)
			{
				
				//reads through the next (max) 8 lines for the data
				while (fileScanner.hasNext()) 
				{
					nextLine = fileScanner.nextLine();
				//checks if there is no more data
					if (nextLine == "\n") break;
					
				//replace brackets
					String currentLine = nextLine.replaceAll("[()]", "");
					
				//split string and grab machine and task as ints
					String[] split = currentLine.split(",");
					int mach = Integer.valueOf(split[0]);
					int task = Integer.valueOf(map.get(split[1]));
				//invalid task check
					if((mach > 8 || mach < 1) || (task > 8 || task < 1) )
					{
						System.out.println("Invalid machine/task");
						break;
					}
				
					
				//change element to true
					forbidden[mach-1][task-1] = true;
				}
				flag++;
			}
			
			if (nextLine == "too-near tasks:" && flag == 3)
			{
				//reads through the next (max) 8 lines for the data
				while (fileScanner.hasNext())
				{
					nextLine = fileScanner.nextLine();
				//checks if there is no more data
					if (nextLine == "\n") break;
					
				//replace brackets
					String currentLine = nextLine.replaceAll("[()]", ",");
					
				//split string and grab machine and task as ints
					String[] split = currentLine.split(",");
					int task1 = Integer.valueOf(map.get(split[0]));
					int task2 = Integer.valueOf(map.get(split[1]));
				//invalid task check
					if((task1 > 8 || task1 < 1) || (task2 > 8 || task2 < 1) )
					{
						System.out.println("Invalid machine/task");
						break;
					}
				
					
				//change element to true
					tooNear[task1-1][task2-1] = true;
				}
				flag++;
			}
			
			
			
			
						/*
			 * Brief description of code:
			 * 1 - if line is equal to "machine penalties"
			 * 2 - Read through 8 lines, check if next Line is "\n"(Missing row)
			 * 3 - Split the row into an array of strings
			 * 4 - Checks if there are exactly 8 elements    (Not enough or too many values)
			 * 5 - Attempt to convert each value to Integer  (Not a number)
			 * 6 - Checks if the value is greater than 0     (Natural number)
			 * 
			 */
			if (nextLine == "machine penalties:" && flag == 4) {
				for (int i = 0; i < 8; i++) {							//Go though 8 rows
					nextLine = fileScanner.nextLine();					//Read Line
					if (nextLine != "\n") {								//If there is an empty row
						
						
						String[] tempArray = nextLine.split(" ", 9);	//Splits first row into array
						
						if (tempArray.length == 8) {
							
							for (int q = 0; q < 8; q++) {				//Loop through each column
								try {									//Try converting to Int
									int val = Integer.parseInt(tempArray[q]);
									if (val > -1) {						//If value greater than 0
										penaltyArray[i][q] = val;
									} else {
										//PENALTY ERROR - LESS THAN ZERO
									}
								} catch (NumberFormatException e) {
									//PENALTY ERROR - NOT AN INTEGER
								}
							}
							
						} else {
							//MACHINE PENALTY ERROR - DOESN'T HAVE 8 VALUES
						}
					} else {
						//MACHINE PENALTY ERROR - MISSING ROW
					}
				}//Exits after reading 8 lines
				//Checks if next line is empty or now
				nextLine = fileScanner.nextLine();
				if (nextLine != "\n") {
					//Error - More than 8 rows
				}
				
				flag++;
			}//End of machine penalties
			
			
			
			if (nextLine == "too-near penalities" && flag == 5) {
				nextLine = fileScanner.nextLine();
				while (nextLine != "/n") {
					String tempLine = nextLine.replaceAll("[()]", "");
					String[] tempSplit = tempLine.split(",");


					int task1 = Integer.valueOf(map.get(tempSplit[0]));
					int task2 = Integer.valueOf(map.get(tempSplit[1]));
					int penalty = Integer.valueOf(tempSplit[2]);


					if((task1 > 8 || task1 < 1) || (task2 > 8 || task2 < 1)){
						System.out.println("Invalid machine/task");
						break;
					}
					
					tooNearPenalty[task1-1][task2-1] = penalty;	
					nextLine = fileScanner.nextLine();
				}
				flag++;
			}
			
			
			
				
		}//End of while loop for reading file
		
		
		//Checks if the 6 sections have been ran
		//1 - Name
		//2 - forced partial assignment
		//3 - forbidden task
		//4 - too near
		//5 - machine penalties
		//6 - too near penalties
		if (flag != 6) {
			//Error while parsing input file
		}
	//output IO
	BufferedWriter fileOutput = new BufferedWriter(new FileWriter(args[1]));
	fileOutput.write(outputString);
	}
	
}
