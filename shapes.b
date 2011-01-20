# setup shapes routine for tetris.
# moved here for inner peace.
#

setup_shapes()
{
     shapes[0].color = 1;
     shapes[0].array_width = 3;
     shapes[0].array_hieght = 2;
     shapes[0].prev_shape = 7;
     shapes[0].next_shape = 7;
     shapes[0].value = array[2] of {  0 => array[3] of {1,1,0}, 
                                      1 => array[3] of {0,1,1} };
     shapes[1].color = 2;
     shapes[1].array_width = 3;
     shapes[1].array_hieght = 2;
     shapes[1].prev_shape = 8;
     shapes[1].next_shape = 8;
     shapes[1].value = array[2] of {  0 => array[3] of {0,2,2}, 
                                      1 => array[3] of {2,2,0} };
     shapes[2].color = 3;
     shapes[2].array_width = 3;
     shapes[2].array_hieght = 2;
     shapes[2].prev_shape = 11;
     shapes[2].next_shape = 9;
     shapes[2].value = array[2] of {  0 => array[3] of {3,3,3}, 
                                      1 => array[3] of {0,3,0} };
     shapes[3].color = 4;
     shapes[3].array_width = 2;
     shapes[3].array_hieght = 2;
     shapes[3].prev_shape = 3;
     shapes[3].next_shape = 3;
     shapes[3].value = array[2] of {  0 => array[2] of {4,4}, 
                                      1 => array[2] of {4,4} };
     shapes[4].color = 5;
     shapes[4].array_width = 3;
     shapes[4].array_hieght = 2;
     shapes[4].prev_shape = 14;
     shapes[4].next_shape = 12;
     shapes[4].value = array[2] of {  0 => array[3] of {5,5,5}, 
                                      1 => array[3] of {5,0,0} };
     shapes[5].color = 6;
     shapes[5].array_width = 3;
     shapes[5].array_hieght = 2;
     shapes[5].prev_shape = 17;
     shapes[5].next_shape = 15;
     shapes[5].value = array[2] of {  0 => array[3] of {6,6,6}, 
                                      1 => array[3] of {0,0,6} };
     shapes[6].color = 7;
     shapes[6].array_width = 4;
     shapes[6].array_hieght = 1;
     shapes[6].prev_shape = 18;
     shapes[6].next_shape = 18;
     shapes[6].value = array[1] of {  0 => array[4] of {7,7,7,7}};

     shapes[7].color = 1;
     shapes[7].next_shape = 0;
     shapes[7].prev_shape = 0;
     shapes[7].array_width = 2;
     shapes[7].array_hieght = 3;
     shapes[7].value = array[3] of {  0 => array[2] of {0,1}, 
                                      1 => array[2] of {1,1}, 
                                      2 => array[2] of {1,0} };
     shapes[8].color = 2;
     shapes[8].array_width = 2;
     shapes[8].array_hieght = 3;
     shapes[8].prev_shape = 1;
     shapes[8].next_shape = 1;
     shapes[8].value = array[3] of {  0 => array[2] of {2,0}, 
                                      1 => array[2] of {2,2}, 
                                      2 => array[2] of {0,2} };
     shapes[9].color = 3;
     shapes[9].array_width = 2;
     shapes[9].array_hieght = 3;
     shapes[9].prev_shape = 2;
     shapes[9].next_shape = 10;
     shapes[9].value = array[3] of {  0 => array[2] of {3,0}, 
                                      1 => array[2] of {3,3}, 
                                      2 => array[2] of {3,0} };
     shapes[10].color = 3;
     shapes[10].array_width = 3;
     shapes[10].array_hieght = 2;
     shapes[10].prev_shape = 9;
     shapes[10].next_shape = 11;
     shapes[10].value = array[2] of { 0 => array[3] of {0,3,0}, 
                                      1 => array[3] of {3,3,3} };
     shapes[11].color = 3;
     shapes[11].array_width = 2;
     shapes[11].array_hieght = 3;
     shapes[11].prev_shape = 10;
     shapes[11].next_shape = 2;
     shapes[11].value = array[3] of { 0 => array[2] of {0,3}, 
                                      1 => array[2] of {3,3}, 
                                      2 => array[2] of {0,3} };
     shapes[12].color = 5;
     shapes[12].array_width = 2;
     shapes[12].array_hieght = 3;
     shapes[12].prev_shape = 4;
     shapes[12].next_shape = 13;
     shapes[12].value = array[3] of { 0 => array[2] of {5,0}, 
                                      1 => array[2] of {5,0}, 
                                      2 => array[2] of {5,5} };
     shapes[13].color = 5;
     shapes[13].array_width = 3;
     shapes[13].array_hieght = 2;
     shapes[13].prev_shape = 12;
     shapes[13].next_shape = 14;
     shapes[13].value = array[2] of { 0 => array[3] of {0,0,5}, 
                                      1 => array[3] of {5,5,5} };
     shapes[14].color = 5;
     shapes[14].array_width = 2;
     shapes[14].array_hieght = 3;
     shapes[14].prev_shape = 13;
     shapes[14].next_shape = 4;
     shapes[14].value = array[3] of { 0 => array[2] of {5,5}, 
                                      1 => array[2] of {0,5},
                                      2 => array[2] of {0,5} };
     shapes[15].color = 6;
     shapes[15].array_width = 2;
     shapes[15].array_hieght = 3;
     shapes[15].prev_shape = 5;
     shapes[15].next_shape = 16;
     shapes[15].value = array[3] of { 0 => array[2] of {6,6}, 
                                      1 => array[2] of {6,0},
                                      2 => array[2] of {6,0} };
     shapes[16].color = 6;
     shapes[16].array_width = 3;
     shapes[16].array_hieght = 2;
     shapes[16].prev_shape = 15;
     shapes[16].next_shape = 17;
     shapes[16].value = array[2] of { 0 => array[3] of {6,0,0}, 
                                      1 => array[3] of {6,6,6} };
     shapes[17].color = 6;
     shapes[17].array_width = 2;
     shapes[17].array_hieght = 3;
     shapes[17].prev_shape = 16;
     shapes[17].next_shape = 5;
     shapes[17].value = array[3] of { 0 => array[2] of {0,6}, 
                                      1 => array[2] of {0,6},
                                      2 => array[2] of {6,6} };
     shapes[18].color = 7;
     shapes[18].array_width = 1;
     shapes[18].array_hieght = 4;
     shapes[18].prev_shape = 6;
     shapes[18].next_shape = 6;
     shapes[18].value = array[4] of { 0 => array[1] of {7}, 
                                      1 => array[1] of {7},
                                      2 => array[1] of {7},
                                      3 => array[1] of {7} };
}

