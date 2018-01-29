// 

//import necessary files
import java.io.*;
import java.util.scanner;


public class mainIO {
	
	public static void main (String[] args) {
	
		BufferedReader fileInput = new BufferedReader(new FileReader(args[0]));
		BufferedWriter fileOutput = new BufferedWriter(new FileWriter(args[1]));
		Scanner fileScanner = new Scanner(fileInput);
		
		while (fileScanner.haxNext()) {
			
			String nextLine = fileScanner.nextLine();
			nextLine = nextLine.trim();
			
			if (nextLine == "forced partial assingnment:") {
				
				int[] forcedAssignArray;
				for (int i=0;  i < 8; i++) 
				{
					forcedAssignArray[i] = -1;
				}
				
				
				for ( int i=0; i < 8; i++) 
				{
					
					nextLine = fileScanner.nextLine();
					
					if (nextLine == "\n") break;
					
					dataLine = nextLine.replaceAll("[(,)]", " ");
					int mach = fileScanner.nextInt(dataLine);
					int task = fileScanner.nextInt(dataLine);
					
					if (forcedAssignArray[mach] != -1)
					{
						//throw exception?? or return some value to indicate failure
						break;
					}
					else 
					{
						forcedAssignArray[mach] = task;
					}
				}
			}
			
			else if (nextLine == "forbidden machine:")
			{
				
			}
				
		}
	}
}

