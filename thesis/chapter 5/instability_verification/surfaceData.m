classdef surfaceData
    %Static data


    properties
        modes
        IC_modes
        staticModeRank

        endCompression
        equilibriumStability
        initialDisplacement
        initialEnergy

        energyLimit
        phyLim
        inputSettings
        fitting_eigenvalues
        eigenvalues
        eigenvectors
        nodeMapping

        P
        Q
        E
        centreDisplacement

        tangentStiffness
        effectiveStiffness
        pCoefficient

        h_Modes
        h_Modes_Low
        h_Modes_High
        hFrequencyCutOff
    end

    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = surfaceData(geometry_def,dispBC,stable,Fq,inc,numStaticSteps,staticSettings,m,mq,eLim,findK)
            FEAPath = 'C:\Users\gg19546\Documents\PhD\Year 1\Snap Through\';
            obj.modes = mq;
            obj.energyLimit = eLim;
            obj.inputSettings = {geometry_def;Fq;inc;numStaticSteps;staticSettings;m;findK;FEAPath};
            obj.equilibriumStability = stable;
            obj.endCompression = dispBC;
            %             FEAPath = '/home/max/Documents/PhD/Year 1/ICE Implementation/';
            if stable == 0
                geoName = geometry_def;
                geometryFile = [geoName,'.inp'];

                gID = fopen([FEAPath,'Geometry\',geometryFile]);
                geometry=textscan(gID,'%s','delimiter','\n');
                geometry = geometry{1,1};
                fclose(gID);

                for i = 1:length(geometry)
                    if strfind(geometry{i,1},'Part-1-1.121, 1, 1, DISP_HERE') == 1
                        geometry{i,1} = ['Part-1-1.121, 1, 1, ',num2str(dispBC)];
                    end
                end

                EVName = ['Geometry\',geoName,'_',num2str(dispBC*1e6),'_matrixData.mat'];
                if exist(EVName,"file")
                    loadMatrices = 1;
                else
                    loadMatrices = 0;
                end

                if loadMatrices == 0
                    [~,~,MBC,KBC,nodeMap] = MatrixExtraction(geometry,FEAPath);
                    DoF = max(nodeMap(:,1));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
                    inpID = fopen('Geometry\stBeam.inp');
                    inp=textscan(inpID,'%s','delimiter','\n');
                    fclose(inpID);
                    inp = inp{1,1};
                    for i = 1:length(inp)
                        if  strfind(inp{i,1},'*Node')
                            break
                        end
                    end

                    x0 = zeros(DoF/6,1);
                    for k = 1:DoF/6
                        x0Temp = textscan(inp{i+k,1},'%f,',4);
                        x0(k) = x0Temp{1}(2);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
                    if dispBC ~= 0
                        datID = fopen('C:\temp\matrix.dat');
                        dat=textscan(datID,'%s','delimiter','\n');
                        fclose(datID);
                        dat = dat{1,1};

                        for i = 1:length(dat)
                            if  strfind(dat{i,1},'S T E P       1     S T A T I C   A N A L Y S I S')
                                iStart = i;
                                break
                            end
                        end


                        for i = iStart:length(dat)
                            if strfind(dat{i,1},'E N E R G Y   O U T P U T')
                                % E0 = str2double(dat{i+8}(26:end));

                                UDat = zeros(DoF/6,7);
                                UShift = 0;
                                for k = 1:DoF/6
                                    if k +UShift > DoF/6
                                        break
                                    end
                                    UTemp = textscan(dat{i+46+k,1},'%f',7);
                                    if k+UShift < UTemp{1,1}(1)
                                        UShift = UShift + 1;
                                    end

                                    UDat(k+UShift,:) = UTemp{1,1};
                                end
                                UDat = UDat(:,2:end)';
                                U0 = reshape(UDat,[DoF,1]);
                                % break
                            end
                        end
                    else
                        U0 = zeros(DoF,1);
                    end

                    DoFBC = length(MBC);


                    xIndex = (0:((DoF-1)/6))*6 + 1;
                    yIndex = (0:((DoF-1)/6))*6 + 2;

                    [~,rowIx,~] = intersect(nodeMap(:,1),xIndex);
                    freeX = ((nodeMap(rowIx,1)-1)/6) + 1;

                    [~,rowIy,~] = intersect(nodeMap(:,1),yIndex);
                    yBCIndex = nodeMap(rowIy,2);

                    dx = U0(xIndex);
                    x0 = x0+dx;
                    x0BC = x0(freeX,1);

                    [~,sortI] = sort(x0BC,'ascend');





                    %Find eigenvalues and modeshapes
                    [eVec,eVal] = eig(KBC,MBC);
                    eVal = eVal*ones(DoFBC,1);
                    %%% Need to be sorted

                    numNeg = length(find(eVal < 0));
                    if numNeg > 0
                        mb = 1:numNeg;
                        mbOrdered = zeros(1,numNeg);
                        modeShapes = eVec(yBCIndex,mb);
                        sortedModeShape = modeShapes(sortI,:);

                        for i = 1:numNeg
                            [~,peakI] = findpeaks(sortedModeShape(:,i));
                            [~,troughI] = findpeaks(-sortedModeShape(:,i));
                            numTP = length(peakI) + length(troughI);
                            mbOrdered(numTP) = mb(i);
                        end

                        eVec(:,mb) = eVec(:,mbOrdered);
                        eVal(mb) = eVal(mbOrdered);
                    end


                    save(EVName,'eVec','eVal','nodeMap','MBC')
                else
                    EVFile = load(EVName);
                    MBC = EVFile.MBC;
                    nodeMap = EVFile.nodeMap;
                    eVec = EVFile.eVec;
                    eVal = EVFile.eVal;
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% STABLE %%%
            elseif stable == 1 || stable == 2
                stable_df = 1;

                geoName = geometry_def;
                geometryFile = [geoName,'Stable.inp'];

                gID = fopen([FEAPath,'Geometry\',geometryFile]);
                geometry=textscan(gID,'%s','delimiter','\n');
                geometry = geometry{1,1};
                fclose(gID);

                for i = 1:length(geometry)
                    if strfind(geometry{i,1},'Part-1-1.121, 1, 1, DISP_HERE') == 1
                        geometry{i,1} = ['Part-1-1.121, 1, 1, ',num2str(dispBC)];
                    end
                    if strfind(geometry{i,1},'LOAD_HERE')
                        loadIndex = i;
                    end
                end

                EVBaseName = ['Geometry\',geoName,'_',num2str(0*1e6),'_matrixData.mat'];
                EVBaseFile = load(EVBaseName);
                MBC_unstable = EVBaseFile.MBC;
                nodemap_unstable = EVBaseFile.nodeMap;
                eVec_unstable = EVBaseFile.eVec;
                eVec1_unstable = eVec_unstable(:,1);

                DoF = max(nodemap_unstable(:,1));
                [forceF,momentF] = forcingCode(stable_df,DoF,eVec1_unstable,nodemap_unstable,MBC_unstable);
                geometry = [geometry(1:(loadIndex-1),1);forceF;momentF;
                    geometry((loadIndex+1):end,1)];

                EVName = ['Geometry\',geoName,'Stable_',num2str(dispBC*1e6),'_matrixData.mat'];
                if exist(EVName,"file")
                    loadMatrices = 1;
                else
                    loadMatrices = 0;
                end

                if loadMatrices == 0                    
                    [~,~,MBC,KBC,nodeMap,geometry] = stableMatrixExtraction(geometry,FEAPath);
                    DoFBC = length(MBC);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
                    DoF = max(nodeMap(:,1));
                    inpID = fopen('Geometry\stBeam.inp');
                    inp=textscan(inpID,'%s','delimiter','\n');
                    fclose(inpID);
                    inp = inp{1,1};
                    for i = 1:length(inp)
                        if  strfind(inp{i,1},'*Node')
                            break
                        end
                    end

                    x0 = zeros(DoF/6,1);
                    for k = 1:DoF/6
                        x0Temp = textscan(inp{i+k,1},'%f,',4);
                        x0(k) = x0Temp{1}(2);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
                    if dispBC ~= 0
                        datID = fopen('C:\temp\matrix.dat');
                        dat=textscan(datID,'%s','delimiter','\n');
                        fclose(datID);
                        dat = dat{1,1};

                        for i = 1:length(dat)
                            if  strfind(dat{i,1},'S T E P       1     S T A T I C   A N A L Y S I S')
                                iStart = i;
                                break
                            end
                        end


                        for i = iStart:length(dat)
                            if strfind(dat{i,1},'E N E R G Y   O U T P U T')
                                % E0 = str2double(dat{i+8}(26:end));

                                UDat = zeros(DoF/6,7);
                                UShift = 0;
                                for k = 1:DoF/6
                                    if k +UShift > DoF/6
                                        break
                                    end
                                    UTemp = textscan(dat{i+46+k,1},'%f',7);
                                    if k+UShift < UTemp{1,1}(1)
                                        UShift = UShift + 1;
                                    end

                                    UDat(k+UShift,:) = UTemp{1,1};
                                end
                                UDat = UDat(:,2:end)';
                                U0 = reshape(UDat,[DoF,1]);
                                % break
                            end
                        end
                    else
                        U0 = zeros(DoF,1);
                    end




                    xIndex = (0:((DoF-1)/6))*6 + 1;
                    yIndex = (0:((DoF-1)/6))*6 + 2;

                    [~,rowIx,~] = intersect(nodeMap(:,1),xIndex);
                    freeX = ((nodeMap(rowIx,1)-1)/6) + 1;

                    [~,rowIy,~] = intersect(nodeMap(:,1),yIndex);
                    yBCIndex = nodeMap(rowIy,2);

                    dx = U0(xIndex);
                    x0 = x0+dx;
                    x0BC = x0(freeX,1);

                    [~,sortI] = sort(x0BC,'ascend');

                    %Find eigenvalues and modeshapes
                    [eVec,eVal] = eig(KBC,MBC);
                    eVal = eVal*ones(DoFBC,1);


                    %numNeg = length(find(eVal < 0));
                    numNeg = 4;
                    if numNeg > 0
                        mb = 1:numNeg;
                        mbOrdered = zeros(1,numNeg);
                        modeShapes = eVec(yBCIndex,mb);
                        sortedModeShape = modeShapes(sortI,:);

                        for i = 1:numNeg
                            [~,peakI] = findpeaks(sortedModeShape(:,i));
                            [~,troughI] = findpeaks(-sortedModeShape(:,i));
                            numTP = length(peakI) + length(troughI);
                            mbOrdered(numTP) = mb(i);
                        end

                        eVec(:,mb) = eVec(:,mbOrdered);
                        eVal(mb) = eVal(mbOrdered);
                    end
                    save(EVName,'eVec','eVal','nodeMap','MBC')
                elseif loadMatrices == 1
                    EVFile = load(EVName);
                    MBC = EVFile.MBC;
                    nodeMap = EVFile.nodeMap;
                    eVec = EVFile.eVec;
                    eVal = EVFile.eVal;
                end
                
            end

            if stable == 2
                
                geoName = geometry_def;
                geometryFile = [geoName,'.inp'];
                gID = fopen([FEAPath,'Geometry\',geometryFile]);
                geometry=textscan(gID,'%s','delimiter','\n');
                geometry = geometry{1,1};
                fclose(gID);

                for i = 1:length(geometry)
                    if strfind(geometry{i,1},'Part-1-1.121, 1, 1, DISP_HERE') == 1
                        geometry{i,1} = ['Part-1-1.121, 1, 1, ',num2str(dispBC)];
                    end
                end
                
                EV_Unstable_Name = ['Geometry\',geoName,'_',num2str(dispBC*1e6),'_matrixData.mat'];
                EV_Unstable = load(EV_Unstable_Name);
                obj.fitting_eigenvalues = EV_Unstable.eVal(mq);

            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.eigenvalues = eVal;
            obj.eigenvectors = eVec;
            obj.nodeMapping = nodeMap;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Calculate Static Data Set
            N = length(mq);

            if N == 1
                Fqr = Fq';
            else
                phiLen = 3+ 2*m;
                thetaLen = 2*phiLen - 1;

                phi = linspace(0,pi,phiLen);
                theta = linspace(0,2*pi,thetaLen);
                theta(end) = [];
                thetaLen = thetaLen - 1;

                numCombs = thetaLen*phiLen^(N-2);
                r = zeros(numCombs,N);

                combInput = cell(1,N-1);
                combInput{1,N-1} = theta;
                for i = 1:N-2
                    combInput{1,i} = phi;
                end

                combs = combvec(combInput{1,:});

                for i = 1:numCombs
                    for j = 1:N
                        rTemp = 1;
                        for k = 1:(j-1)
                            rTemp = rTemp*sin(combs(k,i));
                        end
                        if j < N
                            rTemp = rTemp*cos(combs(j,i));
                        end
                        r(i,j) = rTemp;
                    end
                end

                %%%% remove duplicates
                r(abs(r) < 1e-10) = 0;
                rRound = round(r,5);
                dupeIndex = zeros(numCombs,1);
                for i = 1:numCombs
                    ri = rRound(i,:);
                    for j = (i+1):numCombs
                        if sum(ri == rRound(j,:)) == N
                            dupeIndex(j) = 1;
                        end
                    end
                end

                r(dupeIndex == 1,:) = [];

                rSign = sign(r) == 1;
                rSF = zeros(size(r,1),size(r,2));
                for i = 1:N
                    rSF(rSign(:,i),i) = Fq(i,2);
                    rSF(~rSign(:,i),i) = -Fq(i,1);
                end
                Fqr = rSF.*r;
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Calculate static response in Abaqus
            if isfolder('data\K_temp')
                rmdir('data\K_temp','s')
            end
            mkdir('data\K_temp')

            if isfolder('data\temp')
                rmdir('data\temp','s')
            end
            mkdir('data\temp')

            staticStart = tic;
            [~,QAll,PAll,EAll,Q0,E0,abaqusTime,analysisTime,status] = static_all(eVec,nodeMap,inc,numStaticSteps, ...
                Fqr,mq,eLim,MBC,geometry,staticSettings,FEAPath,findK);
            staticTime = toc(staticStart);

            perAbaqus = round(abaqusTime/(staticTime-abaqusTime)*100,1);
            disp('----------------------------------------------')
            disp(['Done: ',num2str(staticTime),'  (',num2str(perAbaqus),' %  Abaqus) [', ...
                num2str(abaqusTime(1)),' ',num2str(abaqusTime(2)),' ',num2str(analysisTime),']'])
            % disp([num2str(sum(SEPError>0)),' SEP Termination Errors:  +',num2str(round(totalRestartTime,1))])
            disp('----------------------------------------------')

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Data clean up -> cut NaN columns, remove data beyond limits
            obj.P = PAll;
            obj.Q = QAll;
            obj.E = EAll;
            % obj.centreDisplacement = centreDispAll;
            obj = obj.ICModeSelection(0);

            obj.initialDisplacement = Q0;
            obj.initialEnergy = E0;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = addLoadCase(obj,Fqr,numStaticSteps)
            inpSettings = obj.inputSettings;
            geoName = inpSettings{1,1};
            inc = inpSettings{3,1};
            if numStaticSteps == 0
                numStaticSteps = inpSettings{4,1};
            end
            staticSettings = inpSettings{5,1};
            findK = inpSettings{7,1};
            FEAPath = inpSettings{8,1};

            mq = obj.modes;
            eLim = obj.energyLimit;


            EVName = ['Geometry\',geoName,'_matrixData.mat'];
            EVFile = load(EVName);
            MBC = EVFile.MBC;
            nodeMap = EVFile.nodeMap;
            eVec = EVFile.eVec;


            geometryFile = [geoName,'.inp'];
            gID = fopen([FEAPath,'Geometry\',geometryFile]);
            geometry=textscan(gID,'%s','delimiter','\n');
            geometry = geometry{1,1};
            fclose(gID);


            maxInc = 100;  %max number of increments per force step (NOT USED IN FITTING)
            minInc = 1;

            totalTime = 1;
            incMin = totalTime/maxInc;  %smallest increment change
            incMax = totalTime/minInc;
            staticSettings = [incMax/2, totalTime, incMin, incMax];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            staticStart = tic;
            [abaqusTime,status,restartSteps] = static_all(eVec,nodeMap,inc,numStaticSteps, ...
                Fqr,mq,MBC,geometry,staticSettings,FEAPath,findK,[]);
            staticTime = toc(staticStart);


            analysisStart = tic;
            restartPoint = length(obj.E);
            [~,QAll,PAll,EAll,centreDispAll,SEPError] = static_all_analysis(eVec,nodeMap,inc,numStaticSteps,Fqr,mq,MBC,eLim,findK,[0,restartPoint]);
            analysisTime = toc(analysisStart);


            totalTime = round(staticTime + analysisTime,1);
            totalAbaqusTime = sum(abaqusTime);
            inpTime = round(staticTime - totalAbaqusTime,1);
            abaqusTime = round(abaqusTime,1);
            analysisTime = round(analysisTime,1);

            if status ~=0
                disp(['Error: ',num2str(status)])
            end


            perAbaqus = round(totalAbaqusTime/totalTime*100,1);
            disp('----------------------------------------------')
            disp(['Done: ',num2str(totalTime),'  (',num2str(perAbaqus),' %  Abaqus) [', ...
                num2str(inpTime),' ',num2str(abaqusTime(1)),' ',num2str(abaqusTime(2)),' ',num2str(analysisTime),']'])
            % disp([num2str(sum(SEPError>0)),' SEP Termination Errors:  +',num2str(round(totalRestartTime,1))])
            disp('----------------------------------------------')

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Data clean up -> cut NaN columns, remove data beyond limits
            obj.P = cat(2,obj.P,PAll);
            obj.Q = cat(2,obj.Q,QAll);
            obj.E = cat(2,obj.E,EAll);
            obj.centreDisplacement = cat(2,obj.centreDisplacement,centreDispAll);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = ICModeSelection(obj,tol,cutOffRatio)

            QArray = obj.Q;
            mq = obj.modes;
            DoF = size(QArray,1);
            gSpan = 1:DoF;
            gSpan(mq) = [];
            %%%%LOOKING AT ALL VALUES


            qNum = size(QArray,2);
            NS = size(QArray,3);
            qFull = zeros(DoF,qNum*NS);
            for i = 1:NS
                span = ((i-1)*qNum+1):(i*qNum);
                qFull(:,span) = QArray(:,:,i);
            end
            nanIndex = not(isnan(qFull(1,:)));
            qAll = qFull(:,nanIndex);
            q = qAll(mq,:);
            g = abs(qAll(gSpan,:));
            qNorm = sqrt(sum(q.^2,1));

            % qRel = max(g./qNorm,[],2);
            qRel = mean(g./qNorm,2);
            %%%%%%%%%%%%%%%%%%%%%%%
            %
            [~,sortIndex] = sort(qRel,"descend");
            obj.staticModeRank = gSpan(sortIndex);


            if tol == 0
                return
            end

            tolIndex = qRel > tol;
            tolModes = gSpan(tolIndex);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            eVal = obj.eigenvalues;
            freq_r = sqrt(eVal(mq));
            freq_g = sqrt(eVal(gSpan));

            cutOffFreq = max(freq_r)*cutOffRatio;
            cutOffIndex = freq_g <= cutOffFreq;

            hModesLow = gSpan(cutOffIndex);
            gModesHigh = gSpan(~cutOffIndex);

            hModesHigh = intersect(gModesHigh,tolModes);

            disp([num2str(length(hModesLow)),' low frequency modes'])
            disp([num2str(length(hModesHigh)),' high frequency modes'])

            obj.h_Modes = [hModesLow,hModesHigh];
            obj.h_Modes_Low = hModesLow;
            obj.h_Modes_High = hModesHigh;
            obj.hFrequencyCutOff = cutOffFreq;

            %%%% IC IS STILL ALL MODES
            obj.IC_modes = gSpan;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = getTanStiff(obj,surfaceName)

            hModes = obj.h_Modes;
            hModesLow = obj.h_Modes_Low;
            hModesHigh = obj.h_Modes_High;

            eVec = obj.eigenvectors;
            eVec_h = eVec(:,hModes);
            eVec_hT = eVec_h';

            F = obj.P;
            numPoints = size(F,2);

            numhModes = length(hModes);
            numLow = length(hModesLow);
            lowSpan = 1:numLow;
            highSpan = (numLow+1):numhModes;



            obj.h_Modes_Low = hModesLow;
            obj.h_Modes_High = hModesHigh;

            K_path = ['data\',surfaceName,'\K_data\'];
            totalTime = 0;


            Lt = zeros(numhModes,numhModes,numPoints);
            eVec_K = eVec(:,[1,7]);
            eVec_KT =  eVec_K';
            K = zeros(2,2,numPoints);
            %Read mass and stiffness
            for k = 1:numPoints
                SEPStart = tic;

                ktFile = [K_path,'K_',num2str(k),'.mtx'];
                preKt = load(ktFile);
                [~,KtBC] = readMatrix(preKt);
                Lt(:,:,k) = eVec_hT*KtBC*eVec_h;
                % K(:,:,k) = eVec_KT*KtBC*eVec_K;

                SEPEnd = toc(SEPStart);
                totalTime = totalTime + SEPEnd;
                disp([num2str(k),'/',num2str(numPoints),': ',num2str(SEPEnd)])
            end

            C_LL = Lt(lowSpan,lowSpan,:);
            C_LH = Lt(lowSpan,highSpan,:);
            C_HL = Lt(highSpan,lowSpan,:);
            C_HH = Lt(highSpan,highSpan,:);

            prod1 = pagemrdivide(C_LH,C_HH);
            CEff = C_LL - pagemtimes(prod1,C_HL);
            pSF = prod1;

            disp(num2str(totalTime))

            % obj.tangentStiffness = K;
            obj.effectiveStiffness = CEff;
            obj.pCoefficient = pSF;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function staticPlot(obj,fig,phyPlot)
            if exist('fig','var') == 0
                fig = figure;

            end
            Ax = fig.Children;
            if isempty(Ax)
                Ax = axes(fig);
            end
            %Plot static Data
            mq = obj.modes;

            PArray = obj.P;
            EArray = obj.E;
            QArray = obj.Q(mq,:,:);
            centreDispArray = obj.centreDisplacement;

            switch length(mq)
                case 1
                    hold(Ax,'on')
                    for i = 1:2
                        switch phyPlot
                            case 0
                                plot(Ax,QArray,PArray,'k.')
                                xlabel(Ax,['qB',num2str(mq)])
                            case 1
                                plot(Ax,centreDispArray(3,:,i)/1.52e-3,PArray(1,:,i),'k.')
                                xlabel(Ax,'thickness ratio')
                        end
                    end

                    plot(Ax,0,0,'k.','MarkerSize',10)

                    ylabel(Ax,'F')
                    hold(Ax,'off')

                case 2
                    tiledlayout(1,length(mq))
                    numPoints = size(PArray,2);
                    for j = 1:length(mq)
                        Ax = nexttile;
                        hold(Ax,'on')
                        iStart = 1;
                        eLim = obj.energyLimit;
                        for i = 1:(numPoints-1)
                            if (EArray(i) > eLim && EArray(i+1) < eLim) || (EArray(i) > eLim && i+1 == numPoints)
                                plot3(Ax,QArray(1,iStart:i),QArray(2,iStart:i),PArray(j,iStart:i),'x-')
                                iStart = i + 1;
                            end
                        end
                        %                         plot(Ax,xLim,yLim,'k--')



                        xlabel(Ax,['q',num2str(mq(1))])
                        ylabel(Ax,['q',num2str(mq(2))])
                        zlabel(Ax,['F',num2str(j)])
                        hold(Ax,'off')
                    end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function potentialPlot(obj,fig,phyPlot)
            if exist('fig','var') == 0
                fig = figure;
            end
            if strcmp(get(fig,'type'),'figure')
                Ax = fig.Children;
                if isempty(Ax)
                    Ax = axes(fig);
                end
            else
                Ax = fig;
            end

            mq = obj.modes;
            EArray = obj.E;
            QArray = obj.Q(mq,:,:);
            centreDispArray = obj.centreDisplacement;
            nq = size(QArray,1);

            hold(Ax,'on')
            switch nq
                case 1

                    switch phyPlot
                        case 0
                            plot(Ax,squeeze(QArray),squeeze(EArray),'k.')
                            xlabel(Ax,['qB',num2str(mq)])
                        case 1
                            plot(Ax,centreDispArray(3,:,:)/1.52e-3,EArray,'k.')
                            xlabel(Ax,'thickness ratio')
                    end

                case 2
                    iStart = 1;
                    eLim = obj.energyLimit;
                    numPoints = size(EArray,2);
                    for i = 1:(numPoints-1)
                        if (EArray(i) > eLim && EArray(i+1) < eLim) || (EArray(i) > eLim && i+1 == numPoints)
                            plot3(Ax,QArray(1,iStart:i),QArray(2,iStart:i),EArray(1,iStart:i),'-','LineWidth',2)
                            % plot3(Ax,QArray(1,iStart:i),QArray(2,iStart:i),EArray(1,iStart:i),'x-')
                            iStart = i + 1;
                        end
                    end

                    xlabel(Ax,['qB',num2str(mq(1))])
                    ylabel(Ax,['qB',num2str(mq(2))])
                    zlabel(Ax,'V')

            end
            hold(Ax,'off')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function coupledPlot(obj,Ax,cModes)
            %fig is the target for plotting (fig or ax), modesMax is the
            %number of modes shown, forceModes forces the plot to a certain
            %dimension



            QAll = obj.Q;
            NS = size(QAll,3);
            mq = obj.modes;

            numcModes = length(cModes);


            hold(Ax,'on')
            switch length(mq)
                case 1
                    for i = 1:numModes
                        for j = 1:NS
                            plot(Ax,QAll(j,:,mq(1)),QAll(j,:,cModes(i)),'k.','tag',tag)
                        end
                        % plot(Ax,0,obj.qEquilibrium(cModes(i)),'k.','markerSize',16)
                    end
                    xlabel(Ax,['qB',num2str(mq(1))])
                    ylabel(Ax,'qn')


                case 2

                    for i = 1:numcModes
                        % figure;
                        plot3(Ax,QAll(mq(1),:),QAll(mq(2),:),QAll(cModes(i),:),'kx')

                    end

                    xlabel(['qB',num2str(mq(1))])
                    ylabel(['qB',num2str(mq(2))])
                    zlabel('qn')

            end
            hold(Ax,'off')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end



end