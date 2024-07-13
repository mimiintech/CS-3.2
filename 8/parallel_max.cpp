//This version of the parallel program is for debugging purposes. It adds in some print statements that make the
//program slower, but offer some extra info for making the debugging process a little easier

#include <cstdlib>
#include <iostream>
#include <string>
#include <iomanip>
#include <thread>
#include <stdint.h>  //To make sure all ints are 4 bytes regardless of platform

using namespace std;

//Extern function for finding the max of the array

//extern "C" void* findMax(void* args);
extern "C" void findMax(int32_t[], int32_t, int32_t, int32_t*); //Let the compiler know findMax is coming from an external source (an x86 program!)
void printInt(int32_t i) { cout << "Debug int: " << i << endl; }

//Important constants
const int DEFAULT_ARR_SIZE = 100;
const int DEFAULT_THREAD_COUNT = 2;

int main(int argc, char** argv)
{
    int i, threadCount, arrSize;
    int32_t elementsPerThread;
    int32_t* arr;

    if(argc > 3)
    {
        cout << "Error! Too many args!\n Usage = ./par_debug <arr_size> <optional_thread_count>" << endl;
        return 1;
    }
    else if(argc == 1) //If no args, use default values
    {
        threadCount = DEFAULT_THREAD_COUNT;
        arrSize = DEFAULT_ARR_SIZE;
    }
    else if(argc == 2)
    {
        threadCount = DEFAULT_THREAD_COUNT;

        try{ arrSize = stoi(argv[1]); } //Else try to convert arg 1
        catch(...) {
            cout << "Invalid argument! " << argv[1] << " is not an integer for array size." << endl;
            return 1;
        }
    }
    else
    {
        try{ arrSize = stoi(argv[1]); } //Else try to convert arg 1
        catch(...) {
            cout << "Invalid argument! " << argv[1] << " is not an integer for array size." << endl;
            return 1;
        }
        try{ threadCount = stoi(argv[2]); } //Else try to convert arg 2
        catch(...) {
            cout << "Invalid argument! " << argv[2] << " is not an integer." << endl;
            return 1;
        }
    }
    elementsPerThread = arrSize / threadCount;

    //Start by creating the array in serial
	#ifdef DEBUG
    printf("Creating an array of size %i...\n", arrSize);
    cout << "{ 3, 5, ";
	#endif
    arr = new int32_t[arrSize];
    arr[0] = 3;
    arr[1] = 5;
    for(i = 2; i < arrSize; i++)
    {
        arr[i] = (arr[i - 1] - arr[i - 2])/2 + 5*arr[i - 2]/6 - arr[i / 3];
		#ifdef DEBUG
        cout << arr[i] << ", ";
		#endif
    }
    #ifdef DEBUG
    cout << " }" << endl;
    #endif

    //Start all of the threads to find the sum
	#ifdef DEBUG
    printf("Starting %i threads...\n", threadCount);
	#endif
    thread* threads = new thread[threadCount];
    int32_t* maxes = new int[threadCount];
    for(i = 0; i < threadCount - 1; i++) //Set up all of the arguments and start the thread
    {
		#ifdef DEBUG
        cout << "Starting thread " << i << " on range [" << i*elementsPerThread << ", " << i*elementsPerThread + elementsPerThread << ")" << endl;
		#endif
        threads[i] = thread(findMax, arr, i*elementsPerThread, i*elementsPerThread + elementsPerThread, &maxes[i]);
    }
	#ifdef DEBUG
    cout << "Starting thread " << i << " on range [" << i*elementsPerThread << ", " << arrSize << ")" << endl;
	#endif
    threads[i] = thread(findMax, arr, i*elementsPerThread, arrSize, &maxes[i]); //Last thread might contain uneven number of elements compare to other ones

    //Join all of the threads with the main process
    for(i = 0; i < threadCount; i++)
    {
        threads[i].join();
		#ifdef DEBUG
        cout << "Thread " << i << " has joined with max: " << maxes[i] << endl;
		#endif
    }
    
    //Finally merge
	int max = maxes[0];
	for(i = 1; i < threadCount; i++)
		if(maxes[i] > max) max = maxes[i];
    
    cout << "The final max is: " << max << "\n";

    //Deallocate dynamic memory
    delete[] arr;
    delete[] threads;
    delete[] maxes;

    return 0;
}
