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


public class mainIO {
	
	public static void main (String[] args) {
	
		// initializes the main file reader and writer as well as the file scanner
		BufferedReader fileInput = new BufferedReader(new FileReader(args[0]));
		BufferedWriter fileOutput = new BufferedWriter(new FileWriter(args[1]));
		Scanner fileScanner = new Scanner(fileInput);
		
		//initialized the force assignment array, penalty array
		int[] forcedAssignArray;
		int[][] penaltyArray = new int[8][8];
		
		
				
		// while loop to move through the file and check 
		while (fileScanner.hasNext()) {
			
			//assigns the next line to a string to be read and trims it
			String nextLine = fileScanner.nextLine();
			nextLine = nextLine.trim();
			
			//checks and initializes the forced partial assignment array
			if (nextLine == "forced partial assingnment:") {
				
				
				for (int i=0;  i < 8; i++) 
				{
					forcedAssignArray[i] = -1;
				}
				
				//initialized the arraylist for 1 task two machine error
				ArrayList oneTaskTwoMachine = new ArrayList;
				
				//reads through the next (max) 8 lines for the data
				for ( int i=0; i < 8; i++) 
				{
					//progresses down one line to the data
					nextLine = fileScanner.nextLine();
				
					
					//checks if there is no more data
					if (nextLine == "\n") break;
					
					//format the data to be easier to use
					dataLine = nextLine.replaceAll("(", "");
					dataLine = nextLine.replaceAll(",", " ");
					dataLine = nextLine.replaceAll(")", "");
					int mach = fileScanner.nextInt(dataLine);
					int task = fileScanner.nextInt(dataLine);
					
					//check for two task one machine error
					if (forcedAssignArray[mach] != -1)
					{
						//throw exception
						break;
					}
					else 
					{
						//check for one task two machine error
						if (oneTaskTwoMachine.contains(task))
							//throw exception
							break;
							
						oneTaskTwoMachine.add(task);
						
						forcedAssignArray[mach] = task;
					}
				}
			}
			
			
			
			
			
			if (nextLine == "forbidden machine:")
			{
				boolean[][] forbidden = new boolean[8][8];
				//reads through the next (max) 8 lines for the data
				for ( int i=0; i < 8; i++) 
				{
					nextLine = fileScanner.nextLine();
				//checks if there is no more data
					if (nextLine == "\n") break;
					
				//replace everything except numbers to blank
					String currentLine = nextLine.replaceAll("\\D+", "");
				//invalid task check
					if(Character.getNumericValue(currentLine.charAt(0)) > 8 || Character.getNumericValue(currentLine.charAt(1)) > 8)
					{
						System.out.println("Invalid task");
						break;
					}
				//grab machine and task as ints
					int mach = Character.getNumericValue(currentLine.charAt(0));
					int task = Character.getNumericValue(currentLine.charAt(1));
					
				//change element to true
					forbidden[mach-1][task-1] = True;
				}
				
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
			if (nextLine == "machine penalties:") {
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
			}//End of machine penalties
			
			
				
		}//End of while loop for reading file
		
	}
}
