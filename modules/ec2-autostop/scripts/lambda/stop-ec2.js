const { EC2Client, DescribeInstancesCommand, StopInstancesCommand } = require("@aws-sdk/client-ec2");

const ec2 = new EC2Client({ region: "us-east-1" });

module.exports.handler = async () => {
    try {
        console.log('🔍 Buscando instâncias...');

        const result = await ec2.send(new DescribeInstancesCommand({
            Filters: [
                { Name: "tag:AutoStop", Values: ["true"] },
                { Name: "instance-state-name", Values: ["running"] }
            ]
        }));

        const instanceIds = (result.Reservations || [])
            .flatMap(res => res.Instances || [])
            .map(inst => inst.InstanceId);

        if (instanceIds.length === 0) {
            console.log('✅ Nenhuma instância para desligar');
            return;
        }

        console.log(`🔄 Desligando ${instanceIds.length} instância(s): ${instanceIds.join(', ')}`);
        await ec2.send(new StopInstancesCommand({ InstanceIds: instanceIds }));
        console.log('✅ Concluído!');

    } catch (error) {
        console.error('❌ Erro:', error.message);
        throw error;
    }
};