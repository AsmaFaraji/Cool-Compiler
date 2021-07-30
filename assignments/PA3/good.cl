class A {
ana(): Int {
    {
       x <- 2 + 3 - 4;
    }
};
anb(): Int {
    {
    x <- 2;
    if(x=2)
    then
            x <- 1
    else 
           if(x=3)
           then 
                x <- 1
            else
                x <- 4
            
    fi;
    }
};
};

Class BB__ inherits A {
};