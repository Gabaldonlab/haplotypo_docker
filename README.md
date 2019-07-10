# Haplotypo Docker
This Dockerfile builds the Docker image to work with the Haplotypo pipeline.

### Download the last image version
This is our recommended option.
```shell
docker pull cgenomics/haplotypo
```

### Testing the new image
```shell
docker run -it cgenomics/haplotypo python /root/src/haplotypo/bin/haplotypo.py -h
```

### Testing the new image with test data
Process the data inside the image - all data will be lost at the end
```shell
docker run -it -h cgenomics/haplotypo python /root/src/haplotypo/bin/haplotypo.py -o ./shared/output -amb 0 -hapA /root/src/haplotypo/dataset/A.chr7.fa -hapB /root/src/haplotypo/dataset/B.chr7.fa -idA A_AB -idB B_AB -f1 /root/src/haplotypo/dataset/AB.chr7.1.fq.gz -f2 /root/src/haplotypo/dataset/AB.chr7.2.fq.gz -caller GATK
```

### Testing the new image with your own data
Replace {mydataset} and parameters with your dataset folder structure.
It will be created an output folder inside with the result files.
```shell
docker run -v `pwd`/{mydataset}/:/root/src/haplotypo/dataset:rw -it cgenomics/haplotypo \
	python /root/src/haplotypo/bin/haplotypo.py \
	-o /root/src/haplotypo/dataset/output \
	-amb 0 \
	-hapA /root/src/haplotypo/dataset/{myfileA.fa} \
	-hapB /root/src/haplotypo/dataset/{myfileB.fa} \
	-idA A_AB \
	-idB B_AB \
	-f1 /root/src/haplotypo/dataset/{myfileAB.1.fq.gz} \
	-f2 /root/src/haplotypo/dataset/{myfileAB.2.fq.gz} \
	-caller GATK
```

### Running containers

Every time you run a Docker container, it uses the Haplotypo Docker image to remake it.
When the container is closed, everything in it goes away! 
Also, for every one of those containers you need to name it with an alias.

```shell
docker run -dit --name=your-alias -v /your/haplotypo/location:/root/src/haplotypo/shared --rm cgenomics/haplotypo`" 0 0;;
```

### Interactive session in a Haplotypo container
```shell
docker run -it cgenomics/haplotypo
```

## Find Us 
* [GitHub](https://github.com/Gabaldonlab)

## Authors 
Cinta Pegueroles; Veronica Mixao; Laia Carreté; Manu Molina; Toni Gabaldon, PhD

## License 

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
