b = 1/1024*ones(256,1);
fir2coe(b','MOVING_AVERAGE_256');

x = 4*ones(256*10,1);
y = filter(b,1,x);

figure, plot(y)