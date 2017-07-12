p='64_15.bvh';
p='/Users/eruffaldi/Dropbox/ProjectSAILPORT/mocap_perceptionNeuron/Scene_Char00.bvh';
[xds,skel] = bvh.bvhReadFileds(p,'mat');
[xdsq,skel] = bvh.bvhReadFileds(p,'quat');

[r1,ri1] = bvh.findbone(skel,'RightArm');
