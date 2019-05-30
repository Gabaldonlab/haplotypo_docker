# Haplotypo Docker
This Dockerfile builds the Docker image to work with the Haplotypo pipeline.

### Building a new image
Building your docker container will take a few minutes the first time through. 
If you change your script or Dockerfile and need to rebuild, the subsequent times will be faster, since Docker builds things in layers.
```shell
docker build -t cgenomics/haplotypopip:1.0 .
```

### Testing the new image
```shell
docker run -it cgenomics/haplotypo:1.0 python /root/src/haplotypo/bin/haplotypo.py
```

### Testing the new image with fake data
Process the data inside the image - all data will be lost at the end
```shell
docker run -it cgenomics/haplotypo:1.0 python /root/src/haplotypo/bin/haplotypo.py -o ./shared/output -amb 0 -hapA ./dataset/A.chr7.fa -hapB ./dataset/B.chr7.fa -idA A_AB -idB B_AB -f1 ./dataset AB.chr7.1.fq.gz -f2 ./dataset/AB.chr7.2.fq.gz -caller GATK
```

### Testing the new image with real data
Replace {mydataset} and parameters with your dataset folder structure.
It will be created an output folder inside with the result files.
```shell
docker run -v `pwd`/{mydataset}/:/root/src/haplotypo/dataset:rw -it cgenomics/haplotypo:1.0 \
	python /root/src/haplotypo/bin/haplotypo.py \
	-o ./dataset/output \
	-amb 0 \
	-hapA ./dataset/{myfileA.fa} \
	-hapB ./dataset/{myfileB.fa} \
	-idA A_AB \
	-idB B_AB \
	-f1 ./dataset/{myfileAB.1.fq.gz} \
	-f2 ./dataset/{myfileAB.2.fq.gz} \
	-caller GATK
```

### Running containers

Every time you run a Docker container, it uses the Haplotypo Docker image to remake it.
When the container is closed, everything in it goes away! 
Also, for every one of those containers you need to name it with an alias.

```shell
docker run -dit --name=your-alias -v /your/haplotypo/location:/root/src/haplotypo/shared --rm cgenomics/haplotypo:1.0`" 0 0;;
```

### Interactive session in a Haplotypo container
```shell
docker run -it cgenomics/haplotypo:1.0
```

## Find Us 
* [GitHub](https://github.com/Gabaldonlab)

## Authors 

* **Manuel Molina Marín** - *Docker work* - [manumolina](https://github.com/manumolina)

## License 

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
