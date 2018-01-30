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
				
			}
			
			
			
			
			
			
			if (nextLine == "machine penalties:") {
				for (int i = 0; i < 8; i++) {						//Go though 8 rows
					nextLine = fileScanner.nextLine();
					if (nextLine == "\n") {						//If there is an empty row
						
						//MACHINE PENALTY ERROR
						
					} else {
						
						String[] tempArray = nextLine.split(" ", 9);	//Splits first row into array
						
						if (tempArray.length == 8) {
							
							
							for (int q = 0; q < 8; q++) {				//Loop through each column
								try {						//Try converting to Int
									int val = Integer.parseInt(tempArray[q]);
									if (val > -1) {
										penaltyArray[i][q] = val;
									} else {
										//PENALTY ERROR, LESS THAN 0
									}
								} catch (NumberFormatException e) {
									//PENALTY ERROR, NOT AN INT
								}
							}//End of column
							
							
						} else {
							//MACHINE PENALTY ERROR
						}
						
					}
				}
			}//End of machine penalties
			
				
		}//End of while loop for reading file
		
	}
}
