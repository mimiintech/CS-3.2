//This version finds the max of all of the values sequentially - no threads involved

#include <cstdlib>
#include <iostream>
#include <string>
#include <stdint.h>  //To make sure all ints are 4 bytes regardless of platform

using namespace std;

//Important constants
const int DEFAULT_ARR_SIZE = 100;

int main(int argc, char** argv)
{
    int i, arrSize;
    int32_t* arr;

    if(argc > 2)
    {
        printf("Error! Too many args!\n Usage = ./sum_prog_seq <arr_size>\n");
        return 1;
    }
    else if(argc == 1) //If no args, use default value
        arrSize = DEFAULT_ARR_SIZE;
    else 
    {
        try{ arrSize = stoi(argv[1]); } //Else try to convert arg 1
        catch(...) {
            cout << "Invalid argument! " << argv[1] << " is not an integer for array size." << endl;
            return 1;
        }
    }

    //Start by creating the array in serial
    arr = new int32_t[arrSize];
    arr[0] = 3;
    arr[1] = 5;
    for(i = 2; i < arrSize; i++)
        arr[i] = (arr[i - 1] - arr[i - 2])/2 + 5*arr[i - 2]/6 - arr[i / 3];

    //Finally do the max of the entire array
    int max = arr[0];
    for(i = 1; i < arrSize; i++)
	{
		if(arr[i] > max)
			max = arr[i];
	}
    
    printf("The final max is: %i\n", max);

    delete[] arr;

    return 0;
}
