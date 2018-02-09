package assignment;

public class BranchAndBound {
    public static int counter =0;

    public static Node branchAndBound(Node node, Node best, boolean[][] forbidden, boolean[][] tooNear) {
        counter++;
        if (node.getNumAvailableTasks() == 0) {
            // if all tasks are assigned then break out of recursion
            best = node;
        } else {
            // find first open machine not assigned a task
            int machine = node.getFirstAvailableMachine();

            // loop through remaining unassigned task and create a branch for each with machine above
            for(int task : node.getRemainingTasks()) {
                //System.out.println(task);
                
                // Check too near tasks hard constraints for the tasks
                int prevMach = Node.prevMachIndex(machine);
                boolean tooNearPrevFlag = (node.getTaskAtIndex(prevMach) != Node.DUMMY_VALUE) && tooNear[node.getTaskAtIndex(prevMach)][task];

                int nextMach = Node.nextMachIndex(machine);
                boolean tooNearNextFlag = (node.getTaskAtIndex(nextMach) != Node.DUMMY_VALUE) && tooNear[task][node.getTaskAtIndex(nextMach)];

                boolean tooNearFlag = tooNearNextFlag || tooNearPrevFlag;

                 // if too near tasks and forbidden machines constraints met create child node
                if(!tooNearFlag && !forbidden[machine][task]) {
                    // copy parent node information and add new task to open machine
                    Node child = new Node(node, machine, task);

                    // if best node not yet set(not all machines assigned a task
                    // of if subtree rooted at newly created node has a smaller
                    // penalty then the current best
                    if(best == null || (child.getPenaltyPoints() < best.getPenaltyPoints())){
                        // create subtree of new node recursively
                        Node nextNode = branchAndBound(child, best, forbidden, tooNear);

                        // if subtree node has a better penalty then the current best node
                        // assign the best node to be the subtree node


                        if(best == null || (nextNode.getPenaltyPoints() < best.getPenaltyPoints())) {
                            best = nextNode;
                        }

                    }
                }
            }
        }
        return best;
    }
}
