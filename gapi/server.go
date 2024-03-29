package gapi

import (
	"fmt"

	db "github.com/Pleum-Jednipit/simplebank/db/sqlc"
	"github.com/Pleum-Jednipit/simplebank/pb"
	"github.com/Pleum-Jednipit/simplebank/token"
	"github.com/Pleum-Jednipit/simplebank/util"
)

type Server struct {
	pb.UnimplementedSimplebankServer
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewJWTMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("Cannot create token maker: %w", err)
	}
	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
