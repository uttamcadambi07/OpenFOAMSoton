/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\    /   O peration     | Version:  v2212                                 |
|   \\  /    A nd           | Website:  www.openfoam.com                      |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

scale   0.1;

vertices
(
	(0  0   0)	//0
	(20 0   0)	//1
	(20 2.5 0)	//2
	(0  2.5 0)	//3

	(0  0   4)	//4
	(20 0   4)	//5
	(20 2.5 4)	//6
	(0  2.5 4)	//7
);

blocks
(
    hex (0 1 2 3 4 5 6 7) (400 400 1) simpleGrading (1 1 1)
);


boundary
(
	topWall
	{
		type wall;
		faces
		(
			(3 2 6 7)
		);
	}
	
	inlet
	{
		type patch;
 		faces
		(
			(3 7 4 0)
		);
	}
	
	outlet
	{
		type patch;
		faces
		(
			(6 2 1 5)
		);
	}
	
	bottomWall
	{
		type wall;
		faces
		(
			(0 4 5 1)
		);

	}
	frontAndBack
	{
		type empty;
		faces
		(
			(4 7 6 5)
			(3 0 1 2)
		);
	}

);



// ************************************************************************* //
