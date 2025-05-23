# BatLab
Welcome to BatLab. See our research paper for an explanation of what we tried to accomplish and more insight into our research process. It also includes higher level explanations for each part of our code. <br> Briefly: <br>
Birth.m, RoostingNoBirth.m, Swarmingf.m code differential equations and are files for the ode45 solver.<br>
CompareSims.m and runCompareSims.m include the original paper's differential equation for hibernation and the code to compare the results for our hibernation simulation against it.<br>
CompareSims.m is Executable.<br>
hibernation.m is our network based simulation for the hibernation phase.<br>
initGrid.m initializes the grid for our network based simulation.<br>
sim.m runs a full cycle of phases based on however long is desired.<br>
mainSim.m defines all the parameters necessary for sim.m and initial populations to run and then plots a heatmap of the resulting grid after the simulation has completed. (Executable)
