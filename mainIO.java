package assignment;

import java.io.*;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

public class mainIO {
    public static int[][] penaltyArray = new int[8][8];
    public static int[][] tooNearPenalty = new int[8][8];

    public static void main (String args[]) {
        int[] forcedAssignArray = new int[8];
        boolean[][] forbidden = new boolean[8][8];
        boolean[][] tooNear = new boolean[8][8];
        int flag = 0;

        Scanner fileScanner = null;

        try {
            // initializes the main file reader and writer as well as the file scanner
            fileScanner = new Scanner(new BufferedReader(new FileReader(args[0])));
        } catch (IOException e) {
            System.out.println("Input file not found");
        }

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

        try {

            // while loop to move through the file and check
            while (fileScanner.hasNext()) {

                //assigns the next line to a string to be read and trims it
                String nextLine = fileScanner.nextLine();
                nextLine = nextLine.trim();

                //name check
                if (nextLine.equals("Name:") && flag == 0) {
                    fileScanner.nextLine();
                    nextLine = fileScanner.nextLine();
                    flag++;
                }

                //checks and initializes the forced partial assignment array
                if (nextLine.equals("forced partial assignment:") && flag == 1) {

                    //initialize the
                    for (int i = 0; i < 8; i++) {
                        forcedAssignArray[i] = -1;
                    }

                    //initialized the array list for 1 task two machine error
                    ArrayList<Integer> oneTaskTwoMachine = new ArrayList<Integer>();
                    //initialize the string for the current line
                    String currentLine;

                    //reads through the next (max) 8 lines for the data
                    for (int i = 0; i < 8; i++) {
                        //progresses down one line to the data we want
                        nextLine = fileScanner.nextLine();
                        currentLine = nextLine.replaceAll("\\D+", "");//deletes everything except numbers

                        //checks if there is no more data
                        if (nextLine.equals("\n")) break;

                        //format the data to be easier to use
                        int mach = Character.getNumericValue(currentLine.charAt(0));
                        int task = Character.getNumericValue(currentLine.charAt(1));

                        //check if there is a machine or task outside the usable values
                        if (mach > 8) {
                            //thrown invalid Machine error
                            throw new Exception("invalid machine/task");
                            //break;
                        }
                        if (task > 8) {
                            //throw invalidTask error
                            throw new Exception("invalid machine/task");
                            //break;
                        }

                        //check for two task one machine error
                        if (forcedAssignArray[mach] != -1) {
                            //throw exception
                            throw new Exception("partial assignment error");
                            //break;
                        }

                        //check for one task two machine error
                        if (oneTaskTwoMachine.contains(task)) {
                            //throw exception
                            throw new Exception("partial assignment error");
                            //break;
                        } else {
                            //if no errors are thrown adds the value to the arrays
                            oneTaskTwoMachine.add(task);
                            forcedAssignArray[mach - 1] = task;
                        }
                    }

                    flag++;
                }

                if (nextLine.equals("forbidden machine:") && flag == 2) {

                    //reads through the next (max) 8 lines for the data
                    while (fileScanner.hasNext()) {
                        nextLine = fileScanner.nextLine();
                        //checks if there is no more data
                        if (nextLine.equals("\n")) break;

                        //replace brackets
                        String currentLine = nextLine.replaceAll("[()]", "");

                        //split string and grab machine and task as ints
                        String[] split = currentLine.split(",");
                        int mach = Integer.valueOf(split[0]);
                        int task = Integer.valueOf(map.get(split[1]));
                        //invalid task check
                        if ((mach > 8 || mach < 1) || (task > 8 || task < 1)) {
                            System.out.println("invalid machine/task");
                            break;
                        }

                        //change element to true
                        forbidden[mach - 1][task - 1] = true;
                    }
                    flag++;
                }

                if (nextLine.equals("too-near tasks:") && flag == 3) {
                    //reads through the next (max) 8 lines for the data
                    while (fileScanner.hasNext()) {
                        nextLine = fileScanner.nextLine();
                        //checks if there is no more data
                        if (nextLine.equals("\n")) break;

                        //replace brackets
                        String currentLine = nextLine.replaceAll("[()]", ",");

                        //split string and grab machine and task as ints
                        String[] split = currentLine.split(",");
                        int task1 = Integer.valueOf(map.get(split[0]));
                        int task2 = Integer.valueOf(map.get(split[1]));
                        //invalid task check
                        if ((task1 > 8 || task1 < 1) || (task2 > 8 || task2 < 1)) {
                            System.out.println("invalid machine/task");
                            break;
                        }

                        //change element to true
                        tooNear[task1 - 1][task2 - 1] = true;
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
                if (nextLine.equals("machine penalties:") && flag == 4) {
                    for (int i = 0; i < 8; i++) {                            //Go though 8 rows
                        nextLine = fileScanner.nextLine();                    //Read Line
                        if (!nextLine.equals("\n")) {                                //If there is an empty row

                            String[] tempArray = nextLine.split(" ", 9);    //Splits first row into array

                            if (tempArray.length == 8) {

                                for (int q = 0; q < 8; q++) {                //Loop through each column
                                    try {                                    //Try converting to Int
                                        int val = Integer.parseInt(tempArray[q]);
                                        if (val > -1) {                        //If value greater than 0
                                            penaltyArray[i][q] = val;
                                        } else {
                                            throw new Exception("invalid penalty");
                                        }
                                    } catch (NumberFormatException e) {
                                        writeToFile(e.getMessage(), args[1]);
                                    }
                                }

                            } else {
                                throw new Exception("machine penalty error");
                            }
                        } else {
                            throw new Exception("machine penalty error");
                        }
                    }//Exits after reading 8 lines
                    //Checks if next line is empty or now
                    nextLine = fileScanner.nextLine();
                    if (!nextLine.equals("\n")) {
                        throw new Exception("machine penalty error");
                    }

                    flag++;
                }//End of machine penalties

                if (nextLine.equals("too-near penalities") && flag == 5) {
                    for (int i = 0; i < 8; i++) {            //Loop 8 times max
                        nextLine = fileScanner.nextLine();
                        if (nextLine.equals("\n")) {            //If empty line, break
                            break;
                        }

                        String tempLine = nextLine.replaceAll("[^-?0-9]", ",");
                        tempLine = tempLine.replaceAll("(,)+", ",");
                        String[] tempSplit = tempLine.split(",");

                        int task1 = Integer.valueOf(map.get(tempSplit[1]));
                        int task2 = Integer.valueOf(map.get(tempSplit[2]));
                        int penalty = Integer.valueOf(tempSplit[3]);

                        if ((task1 > 8 || task1 < 1) || (task2 > 8 || task2 < 1)) {
                            System.out.println("Invalid task");
                            break;
                        }

                        tooNearPenalty[task1 - 1][task2 - 1] = penalty;
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
                throw new Exception("Error while parsing file");
            }

            //Create nodes and start branch and bound search
            Node rootNode = new Node(forcedAssignArray, forbidden, tooNear);
            Node solution;
            solution = BranchAndBound.branchAndBound(rootNode, null, forbidden, tooNear);
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

    private static void writeToFile(String inputStringToFile, String fileName) {
        try {
            File file = new File(fileName);

            if (!file.exists()) {
                file.createNewFile();
            }

            FileWriter fw = new FileWriter(file.getAbsoluteFile(),false); //false to overwrite, true to append
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
