//
//  OLAFileStream.h
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#ifndef Ola_OLAFileStream_h
#define Ola_OLAFileStream_h

union IFloat{
    float f;
    int i;
};

union LDouble{
    double d;
    long long i;
    char c[8];
};

union CFloat{
    float f;
    char c[4];
};
union BLong{
    long long l;
    char c[8];
};

#endif
