function fir2coe(B,nom)

    fid = fopen([nom '.coe'], 'w+');

    fprintf(fid, 'radix=10;\r\n');
    fprintf(fid, 'coefdata=\r\n');
    for i=1:(length(B)-1)
        fprintf(fid, '%.20f,\n', B(i));
    end
    fprintf(fid, '%.20f;\n',B(end));
    fclose(fid);
%     freqz(B,1);
end
