/*

 */


#pragma once
#include "rt-wdf/rt-wdf.h"


using namespace arma;

class wdfDiodeClipperTree : public wdfTree {

private:
const float r1 = 2.2e3;
const float c1 = 0.01e-6;

std::unique_ptr<wdfTerminatedResVSource> Vin;
std::unique_ptr<wdfTerminatedCap> Cap1;
std::unique_ptr<wdfTerminatedParallel> subtree;

std::string treeName = "Diode Clipper - 44100 Hz";

public:
wdfDiodeClipperTree( ) {

        setSamplerate( 44100 );

        paramData inputGain;
        inputGain.name = "Input Gain";
        inputGain.ID = 0;
        inputGain.type = doubleParam;
        inputGain.value = 0.1;
        inputGain.units = " ";
        inputGain.lowLim = 0;
        inputGain.highLim = 2;
        params.push_back(inputGain);

        Vin.reset(new wdfTerminatedResVSource(0,r1));
        Cap1.reset(new wdfTerminatedCap(c1,1));
        subtree.reset(new wdfTerminatedParallel(Vin.get(), Cap1.get()));
        subtreeCount = 1;
        subtreeEntryNodes = new wdfTreeNode*[subtreeCount];

        root.reset( new wdfRootNL(subtreeCount,{DIODE_AP}, 1) );
        Rp = new double[subtreeCount] ();
}

~wdfDiodeClipperTree() {
        delete subtreeEntryNodes;
        root.reset();
        delete Rp;
}

const char* getTreeIdentifier() {
        return treeName.c_str();
}

int setRootMatrData( matData* rootMats, double *Rp ) {

        // NEEDS TO BE FILLED WITH THE RIGHT SCATTERING VALUES 
        //------------------------- S matrix -------------------------
        if (rootMats->Smat.is_empty()) {
                return -1;
        }
        if (rootMats->Smat.n_cols != 2) {
                return -1;
        }
        if (rootMats->Smat.n_rows != 2) {
                return -1;
        }

        rootMats->Smat.zeros();

        rootMats->Smat.at(0,0) =  9.7786918485531126865595e-01;
        rootMats->Smat.at(0,1) =  2.8360551912666421506964e-04;

        rootMats->Smat.at(1,0) =  2.8360551912666421506964e-04;
        rootMats->Smat.at(1,1) =  9.0475474071387418373291e-01;

        //------------------------- E matrix -------------------------
        if (rootMats->Emat.is_empty()) {
                return -1;
        }
        if (rootMats->Emat.n_rows != 1) {
                return -1;
        }
        if (rootMats->Emat.n_cols != 1) {
                return -1;
        }

        rootMats->Emat.zeros();

        rootMats->Emat.at(0,0) =  1.3360564445206507197539e-02;


        //------------------------- F matrix -------------------------
        if (rootMats->Fmat.is_empty()) {
                return -1;
        }
        if (rootMats->Fmat.n_rows != 1) {
                return -1;
        }
        if (rootMats->Fmat.n_cols != 1) {
                return -1;
        }

        rootMats->Fmat.zeros();

        rootMats->Fmat.at(0,0) = -8.9375176258014311315492e+04;

        //------------------------- M matrix -------------------------
        if (rootMats->Mmat.is_empty()) {
                return -1;
        }
        if (rootMats->Mmat.n_rows != 1) {
                return -1;
        }
        if (rootMats->Mmat.n_cols != 1) {
                return -1;
        }

        rootMats->Mmat.zeros();

        rootMats->Mmat.at(0,0) = -9.6736220346003087833253e-01;


        //------------------------- N matrix -------------------------
        if (rootMats->Nmat.is_empty()) {
                return -1;
        }
        if (rootMats->Nmat.n_rows != 1) {
                return -1;
        }
        if (rootMats->Nmat.n_cols != 1) {
                return -1;
        }

        rootMats->Nmat.zeros();

        rootMats->Nmat.at(0,0) = -1.7821214412707096198574e+05;

        return 0;
}

void setInputValue(double signalIn) {
        Vin->Vs = signalIn;
}

double getOutputValue() {
        return subtree->upPort->getPortVoltage();
}

void setParam(size_t paramID, double paramValue) {
        if (paramID == 0) {
                params[0].value = paramValue;
        }
}
};
