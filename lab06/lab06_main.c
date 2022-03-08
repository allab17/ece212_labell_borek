/* 
 * File:   lab06_main.c
 * Author: labella
 *
 * Created on February 22, 2022, 2:54 PM
 */

#include "ece212.h"

/*
 * 
 */
int main() {
    
    ece212_lafbot_setup();
    
    int sr = 0;
    int sl = 0;
    
//    int full = 0xffff;
//    int off = 0x0000;
    
    delayms(3000);

    while (1) {
        sl = analogRead(LEFT_SENSOR);
        sr = analogRead(RIGHT_SENSOR);
        
        //if the left sensor reads black, move left motor faster than right to reorient
        //if the right sensor reads black, move left motor faster than left to reorient
        //if both sensors are reading white, continue without altering motors
        
        if (sl > 375) {   //if the left sensor is reading black, the right is sped up and left is slowed
            RBACK = 0;
            LBACK = 0;
            RFORWARD = 0xffff;
            LFORWARD = 0x1fff;
            writeLEDs(1000);
                 
        } else if (sr > 375) { //if the right sensor is reading black, left is sped up and right is slowed down
            RBACK = 0;
            LBACK = 0;
            RFORWARD = 0x1fff;
            LFORWARD = 0xffff;
            writeLEDs(0001);
            
        } else {
            RBACK = 0;
            LBACK = 0;
            RFORWARD = 0xffff;
            LFORWARD = 0xffff;
            writeLEDs(0000);
        }
    } 

    return (EXIT_SUCCESS);
}

