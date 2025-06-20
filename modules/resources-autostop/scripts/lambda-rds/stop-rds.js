const {
    RDSClient,
    DescribeDBInstancesCommand,
    ListTagsForResourceCommand,
    StopDBInstanceCommand
} = require("@aws-sdk/client-rds");

const {
    EC2Client,
    DescribeInstancesCommand
} = require("@aws-sdk/client-ec2");

const rds = new RDSClient({ region: "us-east-1" });
const ec2 = new EC2Client({ region: "us-east-1" });

async function processDbInstance(db) {
    const dbArn = db.DBInstanceArn;
    const dbId = db.DBInstanceIdentifier;
    const status = db.DBInstanceStatus;

    const tagsResult = await rds.send(
        new ListTagsForResourceCommand({ ResourceName: dbArn })
    );

    const tags = tagsResult.TagList || [];
    const hasAutoStop = tags.some(tag => tag.Key === "AutoStop" && tag.Value.toLowerCase() === "true");

    if (hasAutoStop && status === "available") {
        console.log(`🛑 Parando RDS: ${dbId}`);
        await rds.send(new StopDBInstanceCommand({ DBInstanceIdentifier: dbId }));
    } else {
        console.log(`⏭️ Ignorado: ${dbId} (Status: ${status}, AutoStop: ${hasAutoStop})`);
    }
}

async function hasRunningAutoStopEc2Instance() {
    const result = await ec2.send(new DescribeInstancesCommand({
        Filters: [
            { Name: "tag:AutoStop", Values: ["true"] },
            { Name: "instance-state-name", Values: ["running"] }
        ]
    }));

    const reservations = result.Reservations || [];
    const instances = reservations.flatMap(r => r.Instances || []);
    return instances.length > 0;
}

module.exports.handler = async () => {
    try {
        const ec2Running = await hasRunningAutoStopEc2Instance();

        if (ec2Running) {
            console.log("⚠️ EC2 com AutoStop=true ainda está rodando. Ignorando pausa de RDS.");
            return;
        }

        console.log("🔍 Buscando instâncias RDS...");

        const result = await rds.send(new DescribeDBInstancesCommand({}));
        const dbs = result.DBInstances || [];

        console.log(`🔍 ${dbs.length} instância(s) RDS encontrada(s).`);

        await Promise.all(dbs.map(processDbInstance));

        console.log("✅ Finalizado!");

    } catch (error) {
        console.error("❌ Erro:", error);
        throw error;
    }
};