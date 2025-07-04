const dgram = require('dgram');
const server = dgram.createSocket('udp4');

server.on('connect', () => {
    console.log('Conexão estabelecida!');
});

server.on('message', (msg, rinfo) => {
    console.log(`Mensagem recebida: ${msg} de ${rinfo.address}:${rinfo.port}`);
});

server.on('close', () => {
    console.log('A conexão foi encerrada!');
});

server.bind(3333);