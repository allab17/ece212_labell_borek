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
    
    int speed_inc = 0xffff;
    
    while (1) {
        sl = analogRead(LEFT_SENSOR);
        sr = analogRead(RIGHT_SENSOR);
        
        //if the left sensor reads black, move left motor faster than right to reorient
        //if the right sensor reads black, move left motor faster than left to reorient
        //if both sensors are reading white, continue without altering motors
        
        if (sl < 255) {   //if the left sensor is reading black, right is sped up
            RBACK = 0;
            LBACK = 0;
            RFORWARD = speed_inc;
            LFORWARD = 0xaaaa;
            writeLEDs(1000);
                 
        } else if (sr < 255) { //if the right sensor is reading black, left is sped up
           RBACK = 0;
            LBACK = 0;
            RFORWARD = 0xaaaa;
            LFORWARD = speed_inc;
            writeLEDs(0001);
            
        } else {
            RBACK = 0;
            LBACK = 0;
            RFORWARD = 0xaaaa;
            LFORWARD = 0xaaaa;
            writeLEDs(0000);
        }
    } 

    return (EXIT_SUCCESS);
}

