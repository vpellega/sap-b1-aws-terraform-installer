const AWS = require('aws-sdk');
const ec2 = new AWS.EC2();
const rds = new AWS.RDS();
const sns = new AWS.SNS();

const SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN;

const isValidMessage = (msg) => typeof msg === "string" && msg.trim().length > 0;

exports.handler = async (event) => {
  const topicArn = event?.overrideTopicArn || process.env.SNS_TOPIC_ARN;
  try {
    const [ec2Instances, rdsInstances] = await Promise.all([
      ec2.describeInstances({
        Filters: [{ Name: "instance-state-name", Values: ["running"] }],
      }).promise(),
      rds.describeDBInstances().promise()
    ]);

    const runningEC2 = ec2Instances.Reservations.flatMap(r => r.Instances).length;
    const runningRDS = rdsInstances.DBInstances.filter(db => db.DBInstanceStatus === "available").length;

    if (runningEC2 || runningRDS) {
      const message = isValidMessage(event?.message)
        ? event.message
        : `🔔 Aviso: ${runningEC2} EC2 e ${runningRDS} RDS ainda estão em execução. Eles serão pausados automaticamente às 23h.`;
      try {
        await sns.publish({ Message: message, TopicArn: topicArn }).promise();
        console.log(`SMS enviado: ${runningEC2.toLocaleString()} EC2, ${runningRDS.toLocaleString()} RDS`);
      } catch (publishErr) {
        console.error("Erro ao enviar SMS:", publishErr);
      }
    } else {
      console.log("Nenhum recurso em execução. Nenhum SMS enviado.");
    }
  } catch (err) {
    console.error("Erro ao verificar recursos ou enviar SMS:", err);
    throw err;
  }
};