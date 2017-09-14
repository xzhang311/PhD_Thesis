% Image Size: 512 X 1024
function RenderRoofControlPointsPDF()
    height=512;
    width=1024;
    [distribution1]=DrawGable(height, width);
    [distribution2]=DrawPramid(height, width);
    [distribution3]=DrawHalfhip(height, width);
    [distribution4]=DrawHip(height, width);
    [distribution5]=DrawGambrel(height, width);
    
    [pdfImg1]=ComputePdfForImage(distribution1, height, width);
    [pdfImg2]=ComputePdfForImage(distribution2, height, width);
    [pdfImg3]=ComputePdfForImage(distribution3, height, width);
    [pdfImg4]=ComputePdfForImage(distribution4, height, width);
    [pdfImg5]=ComputePdfForImage(distribution5, height, width);

    [rgbImg1]=RenderImg(pdfImg1, height, width);
    [rgbImg2]=RenderImg(pdfImg2, height, width);
    [rgbImg3]=RenderImg(pdfImg3, height, width);
    [rgbImg4]=RenderImg(pdfImg4, height, width);
    [rgbImg5]=RenderImg(pdfImg5, height, width);
    
    imwrite(rgbImg1, '/home/xi/Papers/PhDProposal/Pic/PNG/roofkeypointdistribution/gable.png');
    imwrite(rgbImg2, '/home/xi/Papers/PhDProposal/Pic/PNG/roofkeypointdistribution/pramid.png');
    imwrite(rgbImg3, '/home/xi/Papers/PhDProposal/Pic/PNG/roofkeypointdistribution/halfhip.png');
    imwrite(rgbImg4, '/home/xi/Papers/PhDProposal/Pic/PNG/roofkeypointdistribution/hip.png');
    imwrite(rgbImg5, '/home/xi/Papers/PhDProposal/Pic/PNG/roofkeypointdistribution/gambrel.png');
end

function [distribution]=DrawGable(height, width)
    factor=5;

    mean1=[0, height/2];
    sigma1=[50*factor, 0; 0, 500*factor];
    distribution(1).obj=gmdistribution(mean1, sigma1);
    
    mean2=[width, height/2];
    sigma2=[50*factor, 0; 0, 500*factor];
    distribution(2).obj=gmdistribution(mean2, sigma2);
    
end

function [distribution]=DrawPramid(height, width)
    factor=5;

    mean1=[0, 0];
    sigma1=[300*factor, 0; 0, 300*factor];
    distribution(1).obj=gmdistribution(mean1, sigma1);
    
    mean2=[width, 0];
    sigma2=[300*factor, 0; 0, 300*factor];
    distribution(2).obj=gmdistribution(mean2, sigma2);
    
    mean3=[width, height];
    sigma3=[300*factor, 0; 0, 300*factor];
    distribution(3).obj=gmdistribution(mean3, sigma3);
    
    mean4=[0, height];
    sigma4=[300*factor, 0; 0, 300*factor];
    distribution(4).obj=gmdistribution(mean4, sigma4);
    
    mean5=[width/2, height/2];
    sigma5=[1000*factor, 0; 0, 150*factor];
    distribution(5).obj=gmdistribution(mean5, sigma5);
end

function [distribution]=DrawHalfhip(height, width)
    factor=5;

    mean1=[0, 0];
    sigma1=[300*factor, 0; 0, 300*factor];
    distribution(1).obj=gmdistribution(mean1, sigma1);
    
    mean2=[0, height];
    sigma2=[300*factor, 0; 0, 300*factor];
    distribution(2).obj=gmdistribution(mean2, sigma2);
    
    mean3=[width/4, height/2];
    sigma3=[1000*factor, 0; 0, 150*factor];
    distribution(3).obj=gmdistribution(mean3, sigma3);
    
    mean4=[width, height/2];
    sigma4=[50*factor, 0; 0, 500*factor];
    distribution(4).obj=gmdistribution(mean4, sigma4);
end

function [distribution]=DrawHip(height, width)
    factor=5;

    mean1=[0, 0];
    sigma1=[300*factor, 0; 0, 300*factor];
    distribution(1).obj=gmdistribution(mean1, sigma1);
    
    mean2=[width, 0];
    sigma2=[300*factor, 0; 0, 300*factor];
    distribution(2).obj=gmdistribution(mean2, sigma2);
    
    mean3=[width, height];
    sigma3=[300*factor, 0; 0, 300*factor];
    distribution(3).obj=gmdistribution(mean3, sigma3);
    
    mean4=[0, height];
    sigma4=[300*factor, 0; 0, 300*factor];
    distribution(4).obj=gmdistribution(mean4, sigma4);
    
    mean5=[width/4, height/2];
    sigma5=[1000*factor, 0; 0, 150*factor];
    distribution(5).obj=gmdistribution(mean5, sigma5);
    
    mean6=[3*width/4, height/2];
    sigma6=[1000*factor, 0; 0, 150*factor];
    distribution(6).obj=gmdistribution(mean6, sigma6);
end

function [distribution]=DrawGambrel(height, width)
    factor=5;

    mean1=[0, height/2];
    sigma1=[50*factor, 0; 0, 400*factor];
    distribution(1).obj=gmdistribution(mean1, sigma1);
    
    mean2=[width, height/2];
    sigma2=[50*factor, 0; 0, 400*factor];
    distribution(2).obj=gmdistribution(mean2, sigma2);
    
    mean3=[0, height/4];
    sigma3=[50*factor, 0; 0, 600*factor];
    distribution(3).obj=gmdistribution(mean3, sigma3);
    
    mean4=[width, height/4];
    sigma4=[50*factor, 0; 0, 600*factor];
    distribution(4).obj=gmdistribution(mean4, sigma4);
    
    mean5=[0, 3*height/4];
    sigma5=[50*factor, 0; 0, 600*factor];
    distribution(5).obj=gmdistribution(mean5, sigma5);
    
    mean6=[width, 3*height/4];
    sigma6=[50*factor, 0; 0, 600*factor];
    distribution(6).obj=gmdistribution(mean6, sigma6);
end

function [pdfImg]=ComputePdfForImage(distribution, height, width)
    pdfImg=zeros(height, width);
    
    x=[1:width];
    xmat=repmat(x, height, 1);
    y=[1:height]';
    ymat=repmat(y, 1, width);
    xy=[xmat(:), ymat(:)];
    
    P=zeros(width*height, length(distribution));
    for i=1:length(distribution)
        P(:, i)=pdf(distribution(i).obj, xy);
        minP=min(P(:, i));
        maxP=max(P(:, i));
        P(:, i)=(P(:, i)-minP)/(maxP-minP);
    end
    
    tmpPdfImg=sum(P');
    pdfImg=reshape(tmpPdfImg, height, width);
    pdfImg=uint8(mat2gray(pdfImg)*255);
end

function [rgbImg]=RenderImg(pdfImg, height, width)
    cmap=colormap(jet(256));
    imgg=pdfImg(:);
    newimgs=zeros(3, height*width);
    
    for i=1:height*width   
        imgg(i)=min(255, uint16(imgg(i)*1));           % intensify the color     
        newimgs(:, i)=cmap(imgg(i)+1, :);
    end

    r=newimgs(1, :);
    g=newimgs(2, :);
    b=newimgs(3, :);
    
    r=reshape(r, height, width);
    g=reshape(g, height, width);
    b=reshape(b, height, width);
    
    rgbImg=zeros(height, width, 3);
    rgbImg(:, :, 1)=r;
    rgbImg(:, :, 2)=g;
    rgbImg(:, :, 3)=b;
end