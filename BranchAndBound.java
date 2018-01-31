package assignment;

public class BranchAndBound {

    public Node branchAndBound(assignment.Node node, assignment.Node best, boolean[][] forbidden, boolean[][] tooNear) throws Exception {

        if (node.getNumAvailableTasks() == 0) {
            // if all tasks are assigned then break out of recursion
            best = node;
        } else {
            // find first open machine not assigned a task
            int machine = node.getFirstAvailableMachine();

            // loop through remaining unassigned task and create a branch for each with machine above
            for(int task : node.getRemainingTasks()) {

                // Check too near tasks hard constraints for the tasks
                 int prevMach = Node.prevMachIndex(machine);
                 boolean tooNearPrevFlag = node.getTaskAtIndex(prevMach) != Node.DUMMY_VALUE && tooNear[node.getTaskAtIndex(prevMach)][task];

                 int nextMach = Node.nextMachIndex(machine);
                 boolean tooNearNextFlag = node.getTaskAtIndex(nextMach) != Node.DUMMY_VALUE && tooNear[task][node.getTaskAtIndex(nextMach)];

                 boolean tooNearFlag = tooNearNextFlag || tooNearPrevFlag;

                 // if too near tasks and forbidden machines constraints met create child node
                if(!tooNearFlag && !forbidden[machine][task]) {
                    // copy parent node information and add new task to open machine
                    Node child = new Node(node, machine, task);

                    // if best node not yet set(not all machines assigned a task
                    // of if subtree rooted at newly created node has a smaller
                    // penalty then the current best
                    
                    //if(best == null || child.getPenaltyPoints() < best.getPenaltyPoints())
                    if(best == null || child.penalty() < best.penalty()) {
                        // create subtree of new node recursively
                        Node nextNode = branchAndBound(child, best, forbidden, tooNear);

                        // if subtree node has a better penalty then the current best node
                        // assign the best node to be the subtree node

                        // created method in node class to do this and also keeps track of penalty points for nodes when they are created 
                        int nextNodePenalty;
                        if(nextNode == null) { // try moving into next if-statement to create nested
                            nextNodePenalty = Integer.MAX_VALUE;
                        } else {
                            nextNodePenalty = nextNode.penalty();
                        }
                        if(best == null || nextNodePenalty < best.penalty()) {
                            best = nextNode;
                        }

                        /*if(best == null || nextNode.penalty() < best.penalty()) {
                            best = nextNode;
                        }*/

                        // personally preferred version of if-statement
                        /*if(best == null || nextNode.getPenaltyPoints() < best.getPenaltyPoints()) {
                            best = nextNode;
                        }*/

                    }
                }
            }
        }
        return best;
    } 
}
