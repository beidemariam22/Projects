function test(script)
addpath('tests');
if exist('script', 'var')
    run(script);
else
    for script={'testReproject', 'testEstimateTransform', 'testRansacTransform'}
        disp(script)
        run(script);
    end
end