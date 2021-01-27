#include <iostream>
#include <stdio.h>
#include <cstdlib>
using namespace std;

bool finish(const char* err_msg) {
    cerr << err_msg << endl;
    exit(0);
}

unsigned char* readBitmapFile(const char* file_name)
{
    FILE* f = fopen(file_name, "rb");
    if(!f) {
        finish("Cannot open file");
    }

    unsigned char info[54];
    fread(info, sizeof(unsigned char), 54, f);
    fclose(f);

    if(!(info[0] == 'B' && info[1] == 'M')) {
        finish("File is not BMP");
    }

    size_t file_size = *(size_t *)&info[2];

    f = fopen(file_name, "rb");

    unsigned char* buff = new unsigned char[file_size]();
    fread(buff, sizeof(unsigned char), file_size, f);

    fclose(f);

    return buff;
}


extern "C" int func(unsigned char *bitmap, unsigned int *x_pos, unsigned int *y_pos);

int main(int argc, char* argv [])
{
    int result;
    unsigned char* buff = readBitmapFile("source.bmp");
    unsigned int* x_arr = new unsigned int[50]();
    unsigned int* y_arr = new unsigned int[50]();

    result = func(buff, x_arr, y_arr);

    for(int i = 0; i < 50; i++) {
        cout << "x coordinate: " << x_arr[i] << "\t y coordinate: " << y_arr[i] << endl;
    }

    delete[] buff;
    delete[] x_arr;
    delete[] y_arr;
    return 0;
}