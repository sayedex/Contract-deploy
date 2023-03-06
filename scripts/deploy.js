async function Factory(){
    const Factory = await ethers.getContractFactory("MegaNFT");
    const factory = await Factory.deploy("MegaNFT","MNFT","0x0F094331Fd11400604b9419D07E218d583A1aa67");
    console.log("Token address:",factory.address);

  
   } 
   
   Factory().then(() => process.exit(0))
   .catch((error) => {
     console.error(error);
     process.exit(1);
   });
