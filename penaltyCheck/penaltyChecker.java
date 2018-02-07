/**
 * 
 */
package penaltyCheck;

/**
 * @author Amir Siddavatam
 * @version 1.0
 * @since 2018/02/06
 *
 */
public class penaltyChecker {
	
	// GLOBAL VARIABLES
	private int penaltyValue = 0;
	private int[][] machinePenalties = new int[8][8];
	private int[] finalSolution = new int [8];
	private int machineValue = 0;
	private int taskValue = 0;
	
	/**
	 * THIS METHOD CALCULATES THE PENALTY VALUES BY GOING THROUGH THE finalSolution ARRAY
	 * AND GRABBING THE INDEX AS WELL AS THE ELEMENT. AFTER, IT USES THOSE TWO VALUES 
	 * AS COORDINATES TO GO TO THE Penalties ARRAY AND GRAB THE ELEMENT (PENALTY VALUE)
	 * AT THAT INDEX
	 * 
	 * @param finalSolution THE FINAL SOLUTION WITH ALL THE MACHINES ASSOCIATED WITH A TASK
	 * @param penalties ARRAY THAT CONTAINS THE 8X8 MACHINE PENALTIES ARRAY
	 * 
	 * @return penaltyValue RETURNS THE TOTAL NUMBER OF PENALTY'S ACCUMULATED.
	 * 
	 */
	
	public int penalty(int[] finalSolution, int[][] penalties){
		
		/*
		*
		* PARSE THROUGH THE FINAL SOLUTION ARRAY
		* AND GRAB THE INDEX AS WELL AS THE ELEMENT THEN PUT THEM BOTH INTO THE
		* machineValue and taskValue VARIABLES RESPECTIVELY
		*
		*/
		
		for(int i = 0; i < finalSolution.length; i++) {
			taskValue = finalSolution[i];
			machineValue = i;
			System.out.println("Result is: " + taskValue + "," +  machineValue);
			
			/*
			 * TAKE THE taskValue AND machineValue VARIABLES AND USE THEM AS CO-ORDINATES TO LOCATE 
			 * THE PENALTY VALUE WITHIN THE Penalties 2D ARRAY.
			 *  
			 */
			
			 penaltyValue += penalties[machineValue][taskValue];
		}
		System.out.println("Total Penalty value is: " + penaltyValue);
		
		return penaltyValue;
		
	}
}